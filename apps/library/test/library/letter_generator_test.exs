defmodule Library.LetterGeneratorTest do
  use ExUnit.Case
  doctest Library.LetterGenerator

  test "returns empty array for zero letter board" do
    assert Library.LetterGenerator.generate(0) == []
  end

  test "returns empty array for invalid letter board" do
    assert Library.LetterGenerator.generate(-8) == []
  end

  test "returns an array with the input size" do
    lg = Library.LetterGenerator.generate(3)
    assert length(lg) == 3
  end
end
