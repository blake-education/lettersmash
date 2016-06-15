defmodule Library.GameTest do
  use ExUnit.Case

  alias Library.{Game,GamePlayers}

  setup do
    {:ok, game} = Game.start_link("game1")
    Game.add_player(game, %{id: 1, name: "bob", index: "2"})
    {:ok, game: game}
  end

  test "can be started", %{game: game} do
    assert game
  end

  test "list_state - consist of board, players, wordlist and game_over keys", %{game: game} do
    assert %{board: _, players: _, wordlist: _, game_over: _} = Game.list_state(game)
  end

  test "add_player - adds a player to the state map", %{game: game} do
    Game.add_player(game, %{id: 1, name: "abc"})
    assert %{board: _, players: players, wordlist: _, game_over: _} = Game.list_state(game)
    assert length(GamePlayers.display(players)) == 1
  end

  #test "remove_player - removes a player to the state map", %{game: game} do
    #Game.add_player(game, %{id: 1, name: "abc"})
    #assert %{board: _, players: players} = Game.list_state(game)
    #assert length(players) == 1

    #Game.remove_player(game, %{id: 1, name: "abc"})
    #assert %{board: _, players: players} = Game.list_state(game)
    #assert length(players) == 0
  #end

  test "submit_word - with a valid word", %{game: game} do
    word = [%{letter: "C", id: 1, owner: 0, surrounded: false}, %{letter: "A", id: 2, owner: 0, surrounded: false}, %{letter: "N", id: 3, owner: 0, surrounded: false},%{letter: "E", id: 4, owner: 0, surrounded: false}]
    assert :ok = Game.submit_word(game, word, "1")
  end

  test "name returns the name of the game", %{game: game} do
    assert "game1" == Game.name(game)
  end

  test "can start a new game by clearing the board and player scores", %{game: game} do
    word = [%{letter: "C", id: 1, owner: 0, surrounded: false}, %{letter: "A", id: 2, owner: 0, surrounded: false}, %{letter: "N", id: 3, owner: 0, surrounded: false},%{letter: "E", id: 4, owner: 0, surrounded: false}]
    assert :ok = Game.submit_word(game, word, "1")
    Game.new_board(game)
    state = Game.display_state(game)
    assert length(state.wordlist) == 0
    assert state.game_over == false
  end

  test "returns a display_state for the front-end", %{game: game} do
    state = Game.display_state(game)
    assert length(state.players) == 1
    assert length(state.board) == 5 # chunked letters
    assert length(state.wordlist) == 0
    assert state.game_over == false
  end

  test "stats for the lobby", %{game: game} do
    stats = Game.stats(game)
    assert assert stats[:players] == 1
    assert assert stats[:started] == false
  end

  test "words are added to the wordlist when played", %{game: game} do
    word = [%{letter: "C", id: 1, owner: 0, surrounded: false}, %{letter: "A", id: 2, owner: 0, surrounded: false}, %{letter: "V", id: 3, owner: 0, surrounded: false},%{letter: "E", id: 4, owner: 0, surrounded: false}]
    Game.submit_word(game, word, "1")
    state = Game.display_state(game)
    assert length(state.wordlist) == 1
    assert List.first(state.wordlist).word == "CAVE"
  end

  test "game has not started? if no words played", %{game: game} do
    assert Game.started?(game) == false
  end

  test "game has started? if a word has been played", %{game: game} do
    word = [%{letter: "C", id: 1, owner: 0, surrounded: false}, %{letter: "A", id: 2, owner: 0, surrounded: false}, %{letter: "R", id: 3, owner: 0, surrounded: false},%{letter: "E", id: 4, owner: 0, surrounded: false}]
    Game.submit_word(game, word, "1")
    assert Game.started?(game) == true
  end

  test "game is active if is not completed?", %{game: game} do
    assert Game.active?(game) == true
  end
end
