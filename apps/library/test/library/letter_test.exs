defmodule Library.LetterTest do
  use ExUnit.Case
  alias Library.Board
  alias Library.Letter

  test "a letter with no owner is free" do
    assert Letter.free?(%{owner: 0}) == true
  end

  test "a letter with an owner is not free" do
    assert Letter.free?(%{owner: 1}) == false
  end

  test "in a new board no letters are surrounded" do
    board = Board.generate
    Enum.map(board, fn(letter) ->
      assert Letter.surrounded(letter, board, 5, 5) == false
    end)
  end

  test "in a board completed by 1 player all letters are surrounded" do
    new_board = Enum.map(Board.generate, &Map.put(&1, :owner, 22))
    Enum.map(new_board, fn(letter) ->
      assert Letter.surrounded(letter, new_board, 5, 5) == true
    end)
  end

end

