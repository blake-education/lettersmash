defmodule Library.Player do
  alias Skateboard.Event
  alias Skateboard.Repo
  import Ecto.Query, only: [from: 2]

  defstruct name: "", score: 0, id: nil, index: nil

  def save_event(player) do
    Repo.insert(%Event{
      user_id: player.id,
      game_id: 1,
      score: player.score,
      winner: false
    })
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
