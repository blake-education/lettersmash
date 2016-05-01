defmodule Library.Letter do

  @moduledoc """
  the board is composed of letters that have an index, a letter of the alphabet
  and an owner
  """

  def surrounded(letter, board, width, height) do
    if owned?(letter) do
      above(letter, board, width, height) &&
      left(letter, board, width, height) &&
      right(letter, board, width, height) &&
      below(letter, board, width, height)
    else
      false
    end
  end

  def free?(letter), do: letter.owner == 0
  def owned?(letter), do: letter.owner != 0
  defp owners_match(letter, other), do: letter.owner == other.owner

  def above(letter, board, width, height) do
    cond do
      top_row(letter.id, width) -> true
      true ->
        other = Enum.at(board, letter.id - width)
        owners_match(letter, other)
    end
  end

  def left(letter, board, width, height) do
    cond do
      left_row(letter.id, width) -> true
      true ->
        other = Enum.at(board, letter.id - 1)
        owners_match(letter, other)
    end
  end

  def below(letter, board, width, height) do
    cond do
      bottom_row(letter.id, width, height) -> true
      true ->
        other = Enum.at(board, letter.id + width)
        owners_match(letter, other)
    end
  end

  def right(letter, board, width, height) do
    cond do
      right_row(letter.id, width) -> true
      true ->
        other = Enum.at(board, letter.id + 1)
        owners_match(letter, other)
    end
  end

  defp top_row(id, width), do: id < width
  defp bottom_row(id, width, height), do: id > (width * (height - 1)) - 1
  defp left_row(id, width), do: rem(id, width) == 0
  defp right_row(id, width), do: rem(id, width) == width - 1
end
