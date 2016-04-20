defmodule LetterGenerator do

  def generate(0), do: []
  def generate(count) when count < 0, do: []
  def generate(letter_count) do
    letters |>
    pick_words(sample_words) |>
    to_chars_list |>
    get_letters
  end

  defp to_chars_list(list_of_strings) do
    Enum.map list_of_strings, fn(str) ->
      to_char_list str
    end
  end

  defp get_letters(list_of_chars) do
    Enum.concat list_of_chars
  end

  defp pick_words(letter_count, word_list) do
    :random.seed :erlang.now
    Enum.take_random(letter_count, word_list)
  end

  defp vowels do
    ['A', 'E', 'I', 'O', 'U']
  end

  defp consonants do
    ['B', 'C', 'D', 'F', 'G',
     'H', 'J', 'K', 'L', 'M',
     'N', 'P', 'Q', 'R', 'S',
     'T', 'V', 'W', 'X', 'Y']
  end

  defp letters do
    ['A', 'B', 'C', 'D', 'E',
     'F', 'G', 'H', 'I', 'J',
     'K', 'L', 'M', 'N', 'O',
     'P', 'Q', 'R', 'S', 'T',
     'U', 'V', 'W', 'X', 'Y']
  end

  defp sample_words do
    # Note: Get data from Dictionary.words
    ["HAT", "CAT", "MONKEY",
     "BLUE", "RED", "GREEN",
     "TABLE", "CHAIR", "FAN",
     "TROUSERS", "SHIRT", "BLOWSE",
     "DIFFERENT", "SAME", "NOBODY",
     "BABY", "BEAR", "DJ"]
  end
end
