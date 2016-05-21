defmodule Library.GameTest do
  use ExUnit.Case

  alias Library.Game

  setup do
    {:ok, game} = Game.start_link("game1")
    {:ok, game: game}
  end

  test "can be started", %{game: game} do
    assert game
  end

  test "list_state - consist of board and player keys", %{game: game} do

    assert %{board: _, players: _, wordlist: _, game_over: _} = Library.Game.list_state(game)
  end

  test "add_player - adds a player to the state map", %{game: game} do

    Library.Game.add_player(game, %{id: 1, name: "abc"})
    assert %{board: _, players: players} = Library.Game.list_state(game)
    assert length(players) == 1
  end

  test "remove_player - removes a player to the state map", %{game: game} do
    Library.Game.add_player(game, %{id: 1, name: "abc"})
    assert %{board: _, players: players} = Library.Game.list_state(game)
    assert length(players) == 1

    Library.Game.remove_player(game, %{id: 1, name: "abc"})
    assert %{board: _, players: players} = Library.Game.list_state(game)
    assert length(players) == 0
  end

  test "submit_word - with a valid word", %{game: game} do

    word = [%{letter: "C", index: 1}, %{letter: "A", index: 2}, %{letter: "N", index: 3},%{letter: "E", index: 4}]
    player = %{id: 1, name: "abc", index: 2}
    
    assert {:ok, word} = Library.Game.submit_word(game, word, player)
  end
end
