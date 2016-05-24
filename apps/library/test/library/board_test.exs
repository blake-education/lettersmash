defmodule Library.BoardTest do
  use ExUnit.Case, async: true

  alias Library.{Board,Letter}

  setup do
    {:ok, board} = Board.start_link(5, 5)
    {:ok, board: board}
  end

  test "can be started", %{board: board} do
    assert board
  end

  test "is not initially completed", %{board: board} do
    assert Board.completed?(board) == false
  end

  test "players don't own any letters initially", %{board: board} do
    assert Board.letters_owned(board, 0) == 25
  end

  test "adding a word replaces the owner of each letter", %{board: board} do
    word = [%{id: 2, owner: 1, surrounded: false}, %{id: 4, owner: 1, surrounded: false}]
    Board.add_word(board, word, 1)
    assert Board.letters_owned(board, 1) == 2
  end

  test "in a new board no letters are surrounded", %{board: board} do
    Board.letters(board)
    |> Enum.map(fn(letter) ->
      assert Letter.surrounded(letter, board, 5, 5) == false
    end)
  end

  test "a new board can be generated", %{board: board} do
    word = [%{id: 2, owner: 1, surrounded: false}, %{id: 4, owner: 1, surrounded: false}]
    Board.add_word(board, word, 1)
    Board.new_board(board)
    assert Board.letters_owned(board, 0) == 25
  end

  #test "in a board completed by 1 player all letters are surrounded", %{board: board} do
    #new_board = Enum.map(Board.generate, &Map.put(&1, :owner, 22))
    #Enum.map(new_board, fn(letter) ->
      #assert Letter.surrounded(letter, new_board, 5, 5) == true
    #end)
  #end

end
