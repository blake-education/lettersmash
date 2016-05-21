defmodule Library.LetterTest do
  use ExUnit.Case
  alias Library.{Board,Letter}

  test "a letter with no owner is free" do
    assert Letter.free?(%{owner: 0}) == true
  end

  test "a letter with an owner is not free" do
    assert Letter.free?(%{owner: 1}) == false
  end

end

