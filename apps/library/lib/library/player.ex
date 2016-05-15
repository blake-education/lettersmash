defmodule Library.Player do
  alias Skateboard.Event
  alias Skateboard.Repo
  alias Library.Player
  alias Library.Game
  import Ecto.Query, only: [from: 2]

  defstruct name: "", score: 0, id: nil, index: nil, total_score: 0, games_played: 0, games_won: 0

  def save_event(player, winner, game_id) do
    Repo.insert(%Event{
      user_id: player.id,
      game_id: game_id,
      score: player.score,
      winner: player.id == winner.id
    })
    hydrate(player)
  end

  def hydrate(player) do
    %Player{player |
      total_score: Player.total_score(player.id),
      games_played: Player.games_played(player.id),
      games_won: Player.games_won(player.id)
    }
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
