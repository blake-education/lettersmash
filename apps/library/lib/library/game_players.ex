defmodule Library.GamePlayers do

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  def add_player(pid, player) do
    GenServer.call(pid, {:add_player, player})
  end

  def find_player(pid, id) do
    GenServer.call(pid, {:find_player, id})
  end

  def clear_scores(pid) do
    GenServer.call(pid, :clear_scores)
  end

  def update_scores(pid, board) do
    GenServer.call(pid, {:update_scores, board})
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_call({:add_player, player}, _from, state) do
    new_state = [player | state]
    {:reply, new_state, new_state}
  end

  def handle_call({:find_player, id}, _from, state) do
    player = state
    |> Enum.find(fn(p) -> Player.id(p) == id end)
    {:reply, player, state}
  end

  def handle_call(:clear_scores, _from, state) do
    state
    |> Enum.map(&Player.clear_scores(&1))
    {:reply, state, state}
  end

  def handle_call({:update_scores, board}, _from, state) do
    new_state = state
    |> Enum.map(fn(player) ->
      Player.update_score(player, Board.letters_owned(board, Player.get_state(player).index))
    end)
    #|> Enum.sort(&(&1.score > &2.score))
    {:reply, new_state, new_state}
  end

  def handle_call({:save_scores, game_id}, _from, state) do
    state
    |> Enum.map(&Player.save_event(&1, List.first(state), game_id))
    {:reply, state, state}
  end

end
