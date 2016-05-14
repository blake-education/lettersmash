defmodule Library.Player do
  alias Skateboard.Event
  alias Skateboard.Repo

  defstruct name: "", score: 0, id: nil, index: nil

  def save_event(player) do
    Repo.insert(%Event{
      user_id: player.id,
      game_id: 1,
      score: player.score,
      winner: false
    })
  end

end
