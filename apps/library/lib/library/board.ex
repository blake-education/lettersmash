defmodule Library.Board do

  @moduledoc """
  contains functions for manipulating the game board
  """

  alias Library.Letter
  @width 5
  @height 5
  @number_of_letters @width * @height
  @generator Library.LetterGenerator

  def generate do
    @number_of_letters
    |> @generator.generate
    |> Stream.with_index
    |> Enum.map(fn({letter, index}) ->
      %{id: index, letter: letter, owner: 0, surrounded: false}
    end)
  end

  @doc """
  if all letters have an owner the board is completed and the game is over
  """
  def completed?(letters) do
    Enum.all? letters, fn(letter) -> letter.owner != 0 end
  end

  @doc """
  add a word to the board by replacing the owner of the submitted letters
  """
  def add_word(board, word, owner) do
    Enum.reduce(word, board, fn(letter, acc) ->
      replace_letter(acc, letter, String.to_integer(owner))
    end)
  end

  @doc """
  traverse letters, marking as surrounded if all neighbours have same owner
  """
  def surrounded(board) do
    board
    |> Enum.map(fn(letter) ->
      if Letter.surrounded(letter, board, 5, 5) do
        %{letter | surrounded: true}
      else
        %{letter | surrounded: false}
      end
    end)
  end

  defp replace_letter(board, letter, owner) do
    index = letter.id
    current_letter = Enum.at(board, index)
    if current_letter.surrounded do
      board
    else
      List.replace_at(board, index, %{letter | owner: owner})
    end
  end

end
