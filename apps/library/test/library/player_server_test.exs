defmodule Library.PlayerServerTest do
  use ExUnit.Case

  alias Library.{PlayerServer,Player}

  test "can add a player" do
    {:ok, player} = PlayerServer.add_player(%{id: 1, name: "bob", index: 2})
    assert player
  end

  test "can find a player" do
    PlayerServer.add_player(%{id: 17, name: "bob", index: 2})
    player = PlayerServer.find_player(17)
    assert player
  end

  test "can find_or_create a player" do
    player = PlayerServer.find_or_create_player(%{id: 57, name: "tom", index: 3})
    assert player
  end

end
