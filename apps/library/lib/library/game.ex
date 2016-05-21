defmodule Library.Game do
  use GenServer
  alias Library.{Board,Dictionary,Player,Wordlist}

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

  def start_link(name) do
    GenServer.start_link(__MODULE__, name, name: :"#{name}")
  end

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

  def name(pid) do
    GenServer.call(pid, :name)
  end

  def display_state(pid), do: GenServer.call(pid, :display_state)
  def list_state(pid), do: GenServer.call(pid, :list_state)

  def init(name) do
    {:ok, board} = Board.start_link(5, 5)
    {:ok, wordlist} = Wordlist.start_link
    {
      :ok,
      %{
        game_id: Ecto.UUID.generate,
        name: name,
        board: board,
        wordlist: wordlist,
        players: [],
        game_over: false,
        next_index: 1
      }
    }
  end

  def handle_call({:submit_word, word, player_id}, _from, state) do
    cond do
      Wordlist.played?(state.wordlist, word) ->
        {:reply, {:error, "Word already played"}, state}
      Dictionary.invalid?(word) ->
        {:reply, {:error, "Invalid word"}, state}
      state.game_over ->
        {:reply, {:error, "Game Over"}, state}
      true ->
        player = find_player(String.to_integer(player_id), state.players)
        Board.add_word(state.board, word, player)
        Wordlist.add(state.wordlist, word, player)
        new_state =
          %{
            state |
              players: update_players(state.players, state.board, state.game_id),
              game_over: Board.completed?(state.board)
          }
        {:reply, :ok, new_state}
    end
  end

  def handle_call(:list_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:display_state, _from, state) do
    display_state =
      %{
        state |
          board: Enum.chunk(Board.letters(state.board), 5),
          wordlist: Wordlist.words(state.wordlist)
      }
    {:reply, display_state, state}
  end

  def handle_cast({:add_player, player}, state) do
    if find_player(player.id, state.players) do
      {:noreply, state}
    else
      new_player = %Player{id: player.id, name: player.name, index: state.next_index}
      new_player = Player.hydrate(new_player)
      {
        :noreply,
        %{
          state | players: state.players ++ [new_player], next_index: (state.next_index + 1)
        }
      }
    end
  end

  def handle_cast({:remove_player, player}, state) do
    {
      :noreply,
      %{
        state | players: remove_player_from_state(state.players, player)
      }
    }
  end

  def handle_cast(:new_game, state) do
    {
      :noreply,
      %{
        state |
          game_id: Ecto.UUID.generate,
          board: Board.new_board(state.board),
          wordlist: Wordlist.clear(state.wordlist),
          players: clear_scores(state.players),
          game_over: false
      }
    }
  end

  def handle_call(:name, _from, state) do
    {:reply, state[:name], state}
  end

  defp remove_player_from_state(all_players, player) do
    Enum.reject(all_players, &(&1.id == player.id))
  end

  defp find_player(id, players) do
    players
    |> Enum.find(&(&1.id == id))
  end

  defp clear_scores(players) do
    players
    |> Enum.map(&Map.put(&1, :score, 0))
  end

  defp update_scores(players, board) do
    players
    |> Enum.map(fn(player) ->
      %{player | score: Board.letters_owned(board, player.index)}
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
