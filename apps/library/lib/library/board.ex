defmodule Library.Board do

  use GenServer

  @moduledoc """
  contains functions for manipulating the game board
  """

  alias Library.Letter
  alias Library.LetterGenerator

  def start_link(width, height) do
    GenServer.start_link(__MODULE__, {width, height})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def by_row(pid) do
    GenServer.call(pid, :by_row)
  end

  def letters(pid) do
    GenServer.call(pid, :letters)
  end

  @doc """
  if all letters have an owner the board is completed and the game is over
  """
  def completed?(pid) do
    GenServer.call(pid, :completed?)
  end

  @doc """
  add a word to the board by replacing the owner of the submitted letters
  """
  def add_word(pid, word, owner) do
    GenServer.call(pid, {:add_word, word, owner})
  end

  @doc """
  counts how many letters a player owns
  """
  def letters_owned(pid, owner) do
    GenServer.call(pid, {:letters_owned, owner})
  end

  def init({width, height}) do
    {:ok,
      letters: generate(width * height),
      width: width,
      height: height
    }
  end

  def handle_call(:by_row, _from, state) do
    new_state =
      %{
        state |
          letters: Enum.chunk(state.letters, 5)
      }
    {:ok, new_state, state}
  end

  def handle_call(:letters, _from, state) do
    {:ok, state.letters, state}
  end

  def handle_call(:completed?, _from, state) do
    complete = Enum.all? state.letters, fn(letter) -> letter.owner != 0 end
    {:ok, complete, state}
  end

  def handle_call({:add_word, word, owner}, _from, state) do
    new_letters = word
    |> Enum.reduce(state.letters, &(replace_letter(&2, &1, owner)))
    |> surrounded(state.width, state.height)
    new_state =
      %{
        state |
          letters: new_letters
       }
    IO.inspect new_state
    {:ok, new_state, new_state}
  end

  def handle_call({:letters_owned, owner}, _from, state) do
    count = Enum.count(state.letters, &(&1.owner == owner))
    {:ok, count, state}
  end

  def handle_call(:get_state, _from, state) do
    {:ok, state, state}
  end

  defp generate(count) do
    count
    |> LetterGenerator.generate
    |> Stream.with_index
    |> Enum.map(fn({letter, index}) ->
      %{id: index, letter: letter, owner: 0, surrounded: false}
    end)
  end

  defp replace_letter(letters, letter, owner) do
    index = letter.id
    current_letter = Enum.at(letters, letter.id)
    if current_letter.surrounded do
      letters
    else
      List.replace_at(letters, letter.id, %{letter | owner: owner})
    end
  end

  @doc """
  traverse letters, marking as surrounded if all neighbours have same owner
  """
  defp surrounded(letters, width, height) do
    letters
    |> Enum.map(fn(letter) ->
      %{letter | surrounded: Letter.surrounded(letter, letters, width, height)}
    end)
  end

end
