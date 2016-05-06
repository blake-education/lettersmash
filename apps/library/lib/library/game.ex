defmodule Library.Game do
  use GenServer
  alias Library.Board

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

  def add_player(pid, player) do
    GenServer.cast(pid, {:add_player, player})
  end

  def remove_player(pid, player) when is_map(player) do
    GenServer.cast(pid, {:remove_player, player})
  end

  def display_state(pid), do: GenServer.call(pid, :display_state)
  def list_state(pid), do: GenServer.call(pid, :list_state)

  def init(:ok) do
    {
      :ok,
      %{
        board: Board.generate,
        players: [],
        wordlist: [],
        next_index: 1
      }
    }
  end

  def handle_call({:submit_word, word, player}, _from, game_state) do
    # this will delegate out to the dictionary to see if this is a valid word
    #
    # Would love to use this type of system.
    #
    # with {:ok} <- words_consist_of_valid_letters?(word),
    #      {:ok} <- have_not_played_word?(player, word),
    # do:  {:reply, {:ok, word}, game_state}
    # else {:reply, {:error, "word not valid", game_state}}

    # change submitted letters to use atoms for keys rather than strings

    new_board = update_board(word, player, game_state.board)
    new_state =
      %{
        game_state |
          board: new_board,
          players: update_scores(new_board, game_state.players),
          wordlist:  update_wordlist(word, game_state.wordlist)
      }

    {:reply, :ok, new_state}
  end

  def handle_call(:list_state, _from, game_state) do
    {:reply, game_state, game_state}
  end

  def handle_call(:display_state, _from, game_state) do
    board = game_state.board
    |> Board.surrounded
    |> Enum.chunk(5)
    display_board = Map.put game_state, :board, board
    {:reply, display_board, game_state}
  end

  def handle_cast({:add_player, player}, game_state) do
    new_player = Map.put_new(player, :index, game_state.next_index)

    {
      :noreply,
      %{
        game_state | players: game_state.players ++ [new_player], next_index: (game_state.next_index + 1)
      }
    }
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
          board: Board.generate,
          word_list: []
      }
    }
  end


  defp remove_player_from_state(all_players, player) do
    Enum.reject(all_players, &(&1.id == player.id))
  end

  defp atomize_word(word) do
    word
    |> Enum.map(fn(letter) ->
      for {key, val} <- letter, into: %{}, do: {String.to_atom(key), val}
    end)
  end

  defp word_from_letters(letters) do
    letters
    |> Enum.reduce("", fn(letter, acc) ->
      acc <> letter.letter
    end)
  end

  defp update_scores(board, players) do
    players
    |> Enum.map(fn(player) ->
      %{player | score: Board.letter_count(board, player.index) }
    end)
  end

  defp update_board(word, player, board) do
    word
    |> atomize_word
    |> Board.add_word(player, board)
    |> Board.surrounded
  end

  defp update_wordlist(word, wordlist) do
    w = word
    |> atomize_word
    |> word_from_letters
    List.insert_at(wordlist, 0, w)
  end
end
