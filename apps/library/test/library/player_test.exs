defmodule Library.PlayerTest do
  use ExUnit.Case

  use Plug.Test
  alias Library.Player
  alias Skateboard.Repo
  alias Ecto.Adapters.SQL

  setup do
    SQL.begin_test_transaction(Repo)

    on_exit fn ->
      SQL.rollback_test_transaction(Repo)
    end
    {:ok, player} = Player.start_link(%{id: 1, name: "bob", index: 2})
    {:ok, player: player}
  end

  test "can be started", %{player: player} do
    assert player
  end

  test "can return a player's state", %{player: player} do
    state = Player.get_state(player)
    assert state.name == "bob"
    assert state.id == 1
    assert state.score == 0
    assert state.total_score == 0
    assert state.games_played == 0
    assert state.games_won == 0
  end

  test "can return a player's id", %{player: player} do
    id = Player.id(player)
    assert id == 1
  end

  test "clear score", %{player: player} do
    state = Player.update_score(player, 10)
    Player.clear_score(player)
    state = Player.get_state(player)
    assert state.score == 0 
  end

  test "can update a player's score", %{player: player} do
    Player.update_score(player, 20)
    state = Player.get_state(player)
    assert state.score == 20 
  end

  test "can save an event", %{player: player} do
    Player.update_score(player, 17)
    state = Player.save_event(player, 1, "game 1")
    assert state.total_score == 17 
    assert state.games_played == 1 
    assert state.games_won == 1 
  end

  #test "hydrates a player from events" do
    #player = %Player{id: 1, score: 10}
    #winner = %Player{id: 1}
    #p = Player.save_event(player, winner, "1")
    #assert p.games_played == 1
    #assert p.games_won == 1
    #assert p.total_score == 10
  #end

  #test "sources from mulitple events" do
    #player = %Player{id: 1, score: 10}
    #winner = %Player{id: 1}
    #loser = %Player{id: 2}
    #Player.save_event(player, winner, "1")
    #p = Player.save_event(player, loser, "2")
    #assert p.games_played == 2
    #assert p.games_won == 1
    #assert p.total_score == 20
  #end

end
