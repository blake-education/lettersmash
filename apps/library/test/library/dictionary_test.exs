defmodule Library.DictionaryTest do
  use ExUnit.Case
  alias Library.Dictionary

  test "word is valid" do
    word = [%{letter: "h"}, %{letter: "a"},%{letter: "t"}]
    assert Dictionary.invalid?(word) == false
  end

  test "word is invalid" do
    word = [%{letter: "z"}, %{letter: "q"},%{letter: "j"}]
    assert Dictionary.invalid?(word) == true
  end

end
