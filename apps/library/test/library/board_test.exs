defmodule Library.BoardTest do
  use ExUnit.Case
  alias Library.Board

  test "initial board is not completed" do
    board = Board.generate
    assert Board.completed?(board) == false
  end

  test "completely owned board is completed" do
    board = [%{owner: 1}, %{owner: 2}]
    assert Board.completed?(board) == true
  end

  test "generates 25 letters initially" do
    board = Board.generate
    assert Enum.count(board) == 25
  end

  test "adding a word replaces the owner of each letter" do
    word = [%{id: 2, owner: 1}, %{id: 4, owner: 1}]
    updated_board = Board.add_word(Board.generate, word, "1")
    owner_1_count = Enum.count(updated_board, &(&1.owner == 1))
    assert owner_1_count == 2
  end

end
