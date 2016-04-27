defmodule Library.GameTest do
  use ExUnit.Case

  test "list_state - consist of board and player keys" do
    {:ok, pid} = Library.Game.start_link

    assert %{board: _, players: _} = Library.Game.list_state(pid)
  end

  test "add_player - adds a player to the state map" do
    {:ok, pid} = Library.Game.start_link

    Library.Game.add_player(pid, %{id: 1, name: "abc"})
    assert %{board: _, players: players} = Library.Game.list_state(pid)
    assert length(players) == 1
  end

  test "remove_player - adds a player to the state map" do
    {:ok, pid} = Library.Game.start_link

    Library.Game.add_player(pid, %{id: 1, name: "abc"})
    assert %{board: _, players: players} = Library.Game.list_state(pid)
    assert length(players) == 1

    Library.Game.remove_player(pid, %{id: 1, name: "abc"})
    assert %{board: _, players: players} = Library.Game.list_state(pid)
    assert length(players) == 0
  end

  test "submit_word - with a valid word" do
    {:ok, pid} = Library.Game.start_link

    word = "abc"
    player = %{id: 1, name: "abc"}
    
    assert {:ok, word} = Library.Game.submit_word(pid, word, player)
  end
end
