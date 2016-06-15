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

  @doc """
  generates a new set of letters for the board
  """
  def new_board(pid) do
    GenServer.call(pid, :new_board)
  end

  def init({width, height}) do
    {:ok,
      %{
        letters: generate(width * height),
        width: width,
        height: height
      }
    }
  end

  def handle_call(:letters, _from, state) do
    {:reply, state.letters, state}
  end

  def handle_call(:completed?, _from, state) do
    complete = Enum.all? state.letters, fn(letter) -> letter.owner != 0 end
    {:reply, complete, state}
  end

  def handle_call({:add_word, word, owner}, _from, state) do
    new_state =
      %{
        state |
          letters: replace_letters(word, owner, state)
       }
    {:reply, new_state, new_state}
  end

  def handle_call({:letters_owned, owner}, _from, state) do
    count = Enum.count(state.letters, &(&1.owner == owner))
    {:reply, count, state}
  end

  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  def handle_call(:new_board, _from, state) do
    new_state =
      %{
        state |
          letters: generate(state.width * state.height)
       }
    {:reply, new_state, new_state}
  end

  def handle_call(:add_row, _from, state) do
    new_state =
      %{
        state |
          letters: generate(state.width * state.height)
       }
    {:reply, new_state, new_state}
  end

  defp generate(count) do
    count
    |> LetterGenerator.generate
    |> Stream.with_index
    |> Enum.map(fn({letter, index}) ->
      %{id: index, letter: letter, owner: 0, surrounded: false}
    end)
  end

  defp replace_letters(word, owner, state) do
    word
    |> Enum.reduce(state.letters, &(replace_letter(&2, &1, owner)))
    |> surround(state)
  end

  defp replace_letter(tiles, letter, owner) do
    if Enum.at(tiles, letter.id).surrounded do
      tiles
    else
      List.replace_at(tiles, letter.id, %{letter | owner: owner})
    end
  end

  defp surround(tiles, state) do
    tiles
    |> Enum.map(fn(letter) ->
      %{
        letter |
          surrounded: Letter.surrounded(letter, tiles, state.width, state.height)
      }
    end)
  end

end
