defmodule Library.Game do
  use GenServer
  alias Library.{GameServer,Board,Dictionary,Player,Wordlist,GamePlayers,Game}

  @moduledoc """
    The Game module contains all entities required for one game:

    Board
    WordList
    Players

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

  def start_link(name), do: GenServer.start_link(__MODULE__, name, name: :"#{name}")

  def name(pid), do: GenServer.call(pid, :name)
  def submit_word(pid, word, player), do: GenServer.call(pid, {:submit_word, word, player})
  def display_state(pid), do: GenServer.call(pid, :display_state)
  def stats(pid), do: GenServer.call(pid, :stats)
  def list_state(pid), do: GenServer.call(pid, :list_state)
  def started?(pid), do: GenServer.call(pid, :started?)
  def active?(pid), do: GenServer.call(pid, :active?)
  def new_board(pid), do: GenServer.cast(pid, :new_board)
  def add_player(pid, player), do: GenServer.cast(pid, {:add_player, player})
  #def remove_player(pid, player), when is_map(player) do: GenServer.cast(pid, {:remove_player, player})

  def init(name) do
    {:ok, board} = Board.start_link(5, 5)
    {:ok, wordlist} = Wordlist.start_link
    {:ok, game_players} = GamePlayers.start_link
    {
      :ok,
      %{
        game_id: Ecto.UUID.generate,
        name: name,
        board: board,
        wordlist: wordlist,
        players: game_players,
        game_over: Board.completed?(board),
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
        add_word(word, player_id, state)
        new_state =
          %{
            state |
              game_over: Board.completed?(state.board)
          }
        {:reply, :ok, new_state}
    end
  end

  def handle_call(:list_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:display_state, _from, state) do
    model =
      %{
        state |
          board: Enum.chunk(Board.letters(state.board), 5),
          wordlist: Wordlist.words(state.wordlist),
          players: GamePlayers.display(state.players),
          name: state.name
      }
    {:reply, model, state}
  end

  def handle_call(:stats, _from, state) do
    model =
      %{
        name: state.name,
        game_id: state.game_id,
        players: GamePlayers.count(state.players),
        started: started(state)
      }
    {:reply, model, state}
  end

  def handle_call(:name, _from, state) do
    {:reply, state[:name], state}
  end

  def handle_call(:started?, _from, state) do
    {:reply, started(state), state}
  end

  def handle_call(:active?, _from, state) do
    active = !Board.completed?(state.board)
    {:reply, active, state}
  end

  def handle_cast({:add_player, player}, state) do
    if GamePlayers.player_in_game(state.players, player.id) do
      {:noreply, state}
    else
      new_player = Library.PlayerServer.find_or_create_player(Map.put(player, :index, state.next_index))
      GamePlayers.add_player(state.players, new_player)
      {
        :noreply,
        %{
          state |
            next_index: (state.next_index + 1)
        }
      }
    end
  end

  def handle_cast({:remove_player, player}, state) do
    {
      :noreply,
      %{
        state | players: GamePlayers.remove_player(state.players, player)
      }
    }
  end

  def handle_cast(:new_board, state) do
    Board.new_board(state.board)
    Wordlist.clear(state.wordlist)
    GamePlayers.clear_scores(state.players)
    {
      :noreply,
      %{
        state |
          game_id: Ecto.UUID.generate,
          game_over: Board.completed?(state.board)
      }
    }
  end

  defp add_word(word, player_id, state) do
    player = GamePlayers.find_player(state.players, String.to_integer(player_id))
    player_state = Player.get_state(player)
    Board.add_word(state.board, word, player_state.index)
    Wordlist.add(state.wordlist, word, player_state)
    GamePlayers.update_scores(state.players, state.board)
    if Board.completed?(state.board) do
      GamePlayers.save_events(state.players, state.game_id)
    end
  end

  defp started(state) do
    !Enum.empty?(Wordlist.words(state.wordlist))
  end

end
