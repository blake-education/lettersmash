defmodule Library.BoardTest do
  use ExUnit.Case, async: true

  alias Library.Board

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

  test "players don't own any letters initially", %{board: board}  do
    assert Board.letters_owned(board, 0) == 25
  end

  test "adding a word replaces the owner of each letter", %{board: board}  do
    word = [%{id: 2, owner: 1}, %{id: 4, owner: 1}]
    Board.add_word(board, word, 1)
    assert Board.letters_owned(board, 1) == 2
  end

end
