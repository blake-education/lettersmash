defmodule Library.DictionaryTest do
  use ExUnit.Case
  alias Library.Dictionary

  test "word is valid" do
    word = "hello"
    assert Dictionary.check_word(word) == {:valid, word}
  end

  test "proper nouns are downcased" do
    word = "Owen"
    assert Dictionary.check_word(word) == {:invalid, String.downcase(word)}
  end

  test "word is invalid" do
    word = "sdoihfop"
    assert Dictionary.check_word(word) == {:invalid, word}
  end

  test "word which contains numbers is invalid" do
    word = "12345"
    assert Dictionary.check_word(word) == {:invalid, word}
  end
end
