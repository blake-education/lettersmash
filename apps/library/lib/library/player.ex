defmodule Library.Player do

  @moduledoc """
  The Player module represents a player in the game and a summary of
  their history sourced from the events table
  """
  use GenServer

  alias Skateboard.{Repo,Event}
  alias Library.{Player,Game}
  import Ecto.Query, only: [from: 2]

  def start_link(player) do
    GenServer.start_link(__MODULE__, player)
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def id(pid) do
    GenServer.call(pid, :id)
  end

  def save_event(pid, winner, game_id) do
    GenServer.call(pid, {:save_event, winner, game_id})
  end

  def clear_score(pid) do
    GenServer.cast(pid, :clear_score)
  end

  def update_score(pid, score) do
    GenServer.cast(pid, {:update_score, score})
  end

  def init(%{id: id, name: name, index: index}) do
    {:ok,
      %{
        id: id,
        name: name,
        index: index,
        score: 0,
        total_score: 0,
        games_played: 0,
        games_won: 0
      }
    }
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:id, _from, state) do
    {:reply, state.id, state}
  end

  def handle_call({:save_event, winner_id, game_id}, _from, state) do
    Repo.insert(%Skateboard.Event{
      user_id: state.id,
      game_id: game_id,
      score: state.score,
      winner: state.id == winner_id
    })
    new_state =
      %{
        state |
          total_score: total_score(state.id) || 0,
          games_played: games_played(state.id) || 0,
          games_won: games_won(state.id) || 0
      }
    {:reply, new_state, new_state}
  end

  #def hydrate(player) do
    #%Player{player |
      #total_score: Player.total_score(player.id) || 0,
      #games_played: Player.games_played(player.id) || 0,
      #games_won: Player.games_won(player.id) || 0
    #}
  #end

  def handle_cast(:clear_score, state) do
    {:noreply, Map.put(state, :score, 0)}
  end

  def handle_cast({:update_score, score}, state) do
    {:noreply, Map.put(state, :score, score)}
  end

  def total_score(player_id) do
    query = from e in Event,
      where: e.user_id == ^player_id,
      select: sum(e.score)
    Repo.one query
  end

  def games_played(player_id) do
    query = from e in Event,
      where: e.user_id == ^player_id,
      select: count(e.game_id, :distinct)
    Repo.one query
  end

  def games_won(player_id) do
    query = from e in Event,
      where: e.user_id == ^player_id and e.winner == true,
      select: count(e.winner)
    Repo.one query
  end

end
