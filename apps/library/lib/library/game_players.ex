defmodule Library.GamePlayers do

  use GenServer

  alias Library.{Player,Board}

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def add_player(pid, player) do
    GenServer.call(pid, {:add_player, player})
  end

  def remove_player(pid, player) do
    GenServer.call(pid, {:remove_player, player})
  end

  def find_player(pid, id) do
    GenServer.call(pid, {:find_player, id})
  end

  def clear_scores(pid) do
    GenServer.call(pid, :clear_scores)
  end

  def display(pid) do
    GenServer.call(pid, :display)
  end

  def update_scores(pid, board) do
    GenServer.cast(pid, {:update_scores, board})
  end

  def save_events(pid, game_id) do
    GenServer.cast(pid, {:save_events, game_id})
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:add_player, player}, _from, state) do
    Player.hydrate(player)
    new_state = [player | state]
    {:reply, new_state, new_state}
  end

  def handle_call({:remove_player, player}, _from, state) do
    new_state = Enum.reject [player | state]
    {:reply, new_state, new_state}
  end

  def handle_call({:find_player, id}, _from, state) do
    player = state
    |> Enum.find(fn(p) -> Player.id(p) == id end)
    {:reply, player, state}
  end

  def handle_call(:clear_scores, _from, state) do
    state
    |> Enum.map(&Player.clear_score(&1))
    {:reply, state, state}
  end

  def handle_call(:display, _from, state) do
    players = state
    |> Enum.map(fn(player) -> Player.get_state(player) end)
    |> Enum.sort(&(&1.score > &2.score))
    {:reply, players, state}
  end

  def handle_cast({:update_scores, board}, state) do
    state
    |> Enum.map(fn(player) ->
      index = Player.get_state(player).index
      count = Board.letters_owned(board, index)
      Player.update_score(player, count)
    end)
    {:noreply, state}
  end

  def handle_cast({:save_events, game_id}, state) do
    state
    |> Enum.map(&Player.save_event(&1, Player.id(List.first(state)), game_id))
    {:noreply, state}
  end

end
