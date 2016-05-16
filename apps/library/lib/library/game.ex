defmodule Library.Game do
  use GenServer
  alias Library.Board
  alias Library.Dictionary
  alias Library.Player

  @generator Library.LetterGenerator

  @moduledoc """

    _Example_
    iex> Library.Game.add_player(pid, %{id: 1, name: "abc"})
    :ok
    iex> Library.Game.list_state(pid)
    %{board: [], players: [%{id: 1, name: "abc"}]}
    iex> Library.Game.add_player(pid, %{id: 2, name: "dododo"})
    :ok
    iex> Library.Game.list_state(pid)
    %{board: [], players: [%{id: 1, name: "abc"}, %{id: 2, name: "dododo"}]}
    iex> Library.Game.remove_player(pid, %{id: 2})
    :ok
    iex> Library.Game.list_state(pid)
    %{board: [], players: [%{id: 1, name: "abc"}]}
  """

  def start_link, do: GenServer.start_link(__MODULE__, :ok, name: :current_game)

  def submit_word(pid, word, player) do
    GenServer.call(pid, {:submit_word, word, player})
  end

  def new_game(pid) do
    GenServer.cast(pid, :new_game)
  end

  def add_player(pid, player) do
    GenServer.cast(pid, {:add_player, player})
  end

  def remove_player(pid, player) when is_map(player) do
    GenServer.cast(pid, {:remove_player, player})
  end

  def finished?(pid) do
    GenServer.call(pid, :finished?)
  end

  def players(pid) do
    GenServer.call(pid, :players)
  end

  def display_state(pid), do: GenServer.call(pid, :display_state)
  def list_state(pid), do: GenServer.call(pid, :list_state)

  def init(:ok) do
    {
      :ok,
      %{
        game_id: Ecto.UUID.generate,
        board: Board.generate,
        players: [],
        wordlist: [],
        game_over: false,
        next_index: 1
      }
    }
  end

  def handle_call({:submit_word, word, player_id}, _from, game_state) do
    cond do
      word_used_previously(game_state.wordlist, word) ->
        {:reply, {:error, "Word already played"}, game_state}
      invalid_word(word) ->
        {:reply, {:error, "Invalid word"}, game_state}
      game_state.game_over ->
        {:reply, {:error, "Game Over"}, game_state}
      true ->
        player = find_player(String.to_integer(player_id), game_state.players)
        new_board = update_board(word, player, game_state.board)
        new_state =
          %{
            game_state |
              board: new_board,
              players: update_players(game_state.players, new_board, game_state.game_id),
              wordlist: update_wordlist(word, game_state.wordlist, player.index),
              game_over: Board.completed?(new_board)
          }
        {:reply, :ok, new_state}
    end
  end

  def handle_call(:list_state, _from, game_state) do
    {:reply, game_state, game_state}
  end

  def handle_call(:finished?, _from, game_state) do
    {:reply, game_state.game_over, game_state}
  end

  def handle_call(:players, _from, game_state) do
    {:reply, game_state.players, game_state}
  end

  def handle_call(:display_state, _from, game_state) do
    board = game_state.board
    |> Board.surrounded
    |> Enum.chunk(5)
    display_board = Map.put game_state, :board, board
    {:reply, display_board, game_state}
  end

  def handle_cast({:add_player, player}, game_state) do
    if find_player(player.id, game_state.players) do
      { :noreply, game_state }
    else
      new_player = %Player{id: player.id, name: player.name, index: game_state.next_index}
      new_player = Player.hydrate(new_player)
      {
        :noreply,
        %{
          game_state | players: game_state.players ++ [new_player], next_index: (game_state.next_index + 1)
        }
      }
    end
  end

  def handle_cast({:remove_player, player}, game_state) do
    {
      :noreply,
      %{
        game_state | players: remove_player_from_state(game_state.players, player)
      }
    }
  end

  def handle_cast(:new_game, game_state) do
    {
      :noreply,
      %{
        game_state |
          game_id: Ecto.UUID.generate,
          board: Board.generate,
          players: clear_scores(game_state.players),
          wordlist: [],
          game_over: false
      }
    }
  end

  defp remove_player_from_state(all_players, player) do
    Enum.reject(all_players, &(&1.id == player.id))
  end

  defp update_board(word, player, board) do
    word
    |> Board.add_word(player.index, board)
    |> Board.surrounded
  end

  defp update_wordlist(word, wordlist, player_index) do
    List.insert_at(wordlist, 0, %{word: word_string(word), played_by: player_index})
  end

  defp word_string(letters) do
    letters
    |> Enum.reduce("", fn(letter, acc) ->
      acc <> letter.letter
    end)
  end

  defp find_player(id, players) do
    players
    |> Enum.find(&(&1.id == id))
  end

  defp word_used_previously(wordlist, letters) do
    Enum.any?(wordlist, &(&1.word == word_string letters))
  end

  defp invalid_word(letters) do
    case Dictionary.check_word word_string(letters) do
      {:invalid, _} -> true
      _ -> false
    end
  end

  defp clear_scores(players) do
    players
    |> Enum.map(&Map.put(&1, :score, 0))
  end

  defp update_scores(players, board) do
    players
    |> Enum.map(fn(player) ->
      %{player | score: Board.letter_count(board, player.index) }
    end)
    |> Enum.sort(&(&1.score > &2.score))
  end

  def save_events(players, game_id) do
    players
    |> Enum.map(&Player.save_event(&1, List.first(players), game_id))
  end

  def update_players(players, board, game_id) do
    new_players = update_scores(players, board)
    if Board.completed?(board) do
      save_events(new_players, game_id)
    else
      new_players
    end
  end

end
