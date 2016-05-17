defmodule Library.PlayerTest do
  use ExUnit.Case

    #use ExUnit.Case, async: false
  use Plug.Test
  alias Library.Player
  alias Skateboard.Repo
  alias Skateboard.Event
  alias Ecto.Adapters.SQL

  setup do
    SQL.begin_test_transaction(Repo)

    on_exit fn ->
      SQL.rollback_test_transaction(Repo)
    end
  end

  test "hydrates a player from events" do
    player = %Player{id: 1, score: 10}
    winner = %Player{id: 1}
    p = Player.save_event(player, winner, "1")
    assert p.games_played == 1
    assert p.games_won == 1
    assert p.total_score == 10
  end

  test "sources from mulitple events" do
    player = %Player{id: 1, score: 10}
    winner = %Player{id: 1}
    loser = %Player{id: 2}
    p = Player.save_event(player, winner, "1")
    p = Player.save_event(player, loser, "2")
    assert p.games_played == 2
    assert p.games_won == 1
    assert p.total_score == 20
  end

end

