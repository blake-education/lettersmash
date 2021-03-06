defmodule Library.GameServerTest do
  use ExUnit.Case

  alias Library.{GameServer,Game}

  test "can add a game" do
    {:ok, game} = GameServer.add_game("blah_1")
    assert game
    GameServer.delete_game(game)
  end

  test "can find a game" do
    GameServer.add_game("game_0")
    game = GameServer.find_game("game_0")
    assert game
    GameServer.delete_game(game)
  end

  test "can return all games" do
    {:ok, game} = GameServer.add_game("game_1")
    assert length(GameServer.games) == 1
    GameServer.delete_game(game)
  end

  test "can return stats" do
    {:ok, game} = GameServer.add_game("game_1")
    assert length(GameServer.stats) == 1
    GameServer.delete_game(game)
  end

end
