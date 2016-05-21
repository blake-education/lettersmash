defmodule Library.GameTest do
  use ExUnit.Case

  alias Library.Game

  setup do
    {:ok, game} = Game.start_link("game1")
    Game.add_player(game, %{id: 1, name: "bob", index: "2"})
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
    assert %{board: _, players: players, wordlist: _, game_over: _} = Library.Game.list_state(game)
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

    word = [%{letter: "C", id: 1, owner: 0, surrounded: false}, %{letter: "A", id: 2, owner: 0, surrounded: false}, %{letter: "N", id: 3, owner: 0, surrounded: false},%{letter: "E", id: 4, owner: 0, surrounded: false}]
    
    assert :ok = Library.Game.submit_word(game, word, "1")
  end
end
