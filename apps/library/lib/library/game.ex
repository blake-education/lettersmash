defmodule Library.Game do
  use GenServer
  alias Library.{Board,Dictionary,Player,Wordlist,PlayerServer,GamePlayers}

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

  #def remove_player(pid, player) when is_map(player) do
    #GenServer.cast(pid, {:remove_player, player})
  #end

  def name(pid) do
    GenServer.call(pid, :name)
  end

  def display_state(pid), do: GenServer.call(pid, :display_state)
  def list_state(pid), do: GenServer.call(pid, :list_state)

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
        player = find_player(state.players, String.to_integer(player_id))
        player_state = Player.get_state(player)
        Board.add_word(state.board, word, player_state.index)
        Wordlist.add(state.wordlist, word, player_state)
        GamePlayers.update(state.players, state.board)
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
    players = Map.values(state.players)
    |> Enum.map(&Player.get_state(&1))
    display_state =
      %{
        state |
          board: Enum.chunk(Board.letters(state.board), 5),
          wordlist: Wordlist.words(state.wordlist),
          players: GamePlayers.display(state.players),
      }
    {:reply, display_state, state}
  end

  def handle_cast({:add_player, player}, state) do
    if find_player(state.players, player.id) do
      {:noreply, state}
    else
      {:ok, new_player} = Library.PlayerServer.add_player(Map.put(player, :index, state.next_index))
      {
        :noreply,
        %{
          state |
            players: Map.put(state.players, player.id, new_player),
            next_index: (state.next_index + 1)
        }
      }
    end
  end

  #def handle_cast({:remove_player, player}, state) do
    #{
      #:noreply,
      #%{
        #state | players: remove_player_from_state(state.players, player)
      #}
    #}
  #end

  def handle_cast(:new_game, state) do
    Board.new_board(state.board)
    Wordlist.clear(state.wordlist)
    GamePlayers.clear_scores(state.players)
    {
      :noreply,
      %{
        state |
          game_id: Ecto.UUID.generate,
          game_over: false
      }
    }
  end

  def handle_call(:name, _from, state) do
    {:reply, state[:name], state}
  end

  #defp remove_player_from_state(all_players, player) do
    #Enum.reject(all_players, &(&1.id == player.id))
  #end

  defp find_player(players, id) do
    Map.get(players, id)
  end


end
