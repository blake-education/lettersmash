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
    player = PlayerServer.find_or_create_player(%{id: 57, name: "tom", index: 3})
    GamePlayers.add_player(game_players, player)
    player = GamePlayers.find_player(game_players, 57)
    assert player
  end

  test "can clear player scores", %{game_players: game_players} do
    player = PlayerServer.find_or_create_player(%{id: 57, name: "tom", index: 3})
    Player.update_score(player, 100)
    players = GamePlayers.add_player(game_players, player)
    GamePlayers.clear_scores(game_players)
    |> Enum.map(fn(player) -> assert Player.get_state(player).score == 0 end)
  end

  test "can update player scores", %{game_players: game_players} do
    player = PlayerServer.find_or_create_player(%{id: 57, name: "tom", index: 3})
    players = GamePlayers.add_player(game_players, player)
    GamePlayers.update_scores(game_players, board)
    |> Enum.map(fn(player) -> assert Player.get_state(player).score == 0 end)
  end

  test "can save events", %{game_players: game_players} do
    player = PlayerServer.find_or_create_player(%{id: 157, name: "tom", index: 3})
    Player.update_score(player, 300)
    GamePlayers.add_player(game_players, player)
    player = PlayerServer.find_or_create_player(%{id: 158, name: "bill", index: 4})
    Player.update_score(player, 300)
    GamePlayers.add_player(game_players, player)
    GamePlayers.save_events(game_players, "10010")
    GamePlayers.display(game_players)
    |> Enum.map(&(assert &1.total_score == 300))
  end

  test "can return display representation", %{game_players: game_players} do
    player = PlayerServer.find_or_create_player(%{id: 57, name: "tom", index: 3})
    GamePlayers.add_player(game_players, player)
    player = PlayerServer.find_or_create_player(%{id: 5, name: "bill", index: 4})
    GamePlayers.add_player(game_players, player)
    display = GamePlayers.display(game_players)
    assert length(display) == 2
  end

end
