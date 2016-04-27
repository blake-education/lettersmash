defmodule Library.LetterGenerator do
  @moduledoc """
    Generate a list of random letters based on self defined frequency.
  """

  def generate(count) when count <= 0, do: []
  def generate(num_of_letters) do
    :random.seed :erlang.now
    Enum.take_random letters_with_frequencies, num_of_letters
  end

  defp letters_with_frequencies do
    [
      'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A', 'A',
      'B', 'B',
      'C', 'C', 'C', 'C',
      'D', 'D', 'D', 'D', 'D',
      'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E', 'E',
      'F', 'F', 'F',
      'G', 'G', 'G',
      'H', 'H', 'H', 'H', 'H', 'H', 'H',
      'I', 'I', 'I', 'I', 'I', 'I', 'I', 'I',
      'J',
      'K',
      'L', 'L', 'L', 'L', 'L',
      'M', 'M', 'M',
      'N', 'N', 'N', 'N', 'N', 'N', 'N', 'N',
      'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O', 'O',
      'P', 'P', 'P',
      'Q',
      'R', 'R', 'R', 'R', 'R', 'R', 'R',
      'S', 'S', 'S', 'S', 'S', 'S', 'S',
      'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T', 'T',
      'U', 'U', 'U', 'U',
      'V',
      'W', 'W', 'W',
      'X',
      'Y', 'Y', 'Y',
      'Z'
     ]
  end
end
