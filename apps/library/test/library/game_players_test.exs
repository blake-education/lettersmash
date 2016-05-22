defmodule Library.GamePlayersTest do
  use ExUnit.Case, async: true

  alias Library.{Board,Player,PlayerServer,GamePlayers}

  setup do
    {:ok, game_players} = GamePlayers.start_link
    {:ok, game_players: game_players}
  end

  test "can add a player", %{game_players: game_players} do
    player = PlayerServer.find_or_create_player(%{id: 57, name: "tom", index: 3})
    players = GamePlayers.add_player(game_players, player)
    assert length(players) == 1
  end

  test "can find a player", %{game_players: game_players} do
    flunk "implement me!"
  end

  test "can clear player scores", %{game_players: game_players} do
    flunk "implement me!"
  end

  test "can update player scores", %{game_players: game_players} do
    flunk "implement me!"
  end

  test "can save player scores", %{game_players: game_players} do
    flunk "implement me!"
  end

  test "can return display representation", %{game_players: game_players} do
    flunk "implement me!"
  end

end
