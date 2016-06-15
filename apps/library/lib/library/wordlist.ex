defmodule Library.Wordlist do

  use GenServer

  @moduledoc """
  contains functions for tracking the words played during a game
  """

  def start_link do
    GenServer.start_link(__MODULE__, :ok)
  end

  @doc """
  return the list of words
  """
  def words(pid) do
    GenServer.call(pid, :words)
  end

  @doc """
  has the word been played
  """
  def played?(pid, word) do
    GenServer.call(pid, {:played?, word})
  end

  @doc """
  clears the list
  """
  def clear(pid) do
    GenServer.cast(pid, :clear)
  end

  @doc """
  add a word and player to the list
  """
  def add(pid, word, player) do
    GenServer.cast(pid, {:add, word, player})
  end

  def init(:ok) do
    {:ok, []}
  end

  def handle_call(:words, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:played?, word}, _from, state) do
    played = Enum.any?(state, &(&1.word == word_string(word)))
    {:reply, played, state}
  end

  def handle_cast(:clear, _) do
    {:noreply, []}
  end

  def handle_cast({:add, word, player}, state) do
    new_state = List.insert_at(state, 0, %{word: word_string(word), played_by: player.index})
    {:noreply, new_state}
  end

  defp word_string(word) do
    Enum.reduce(word, "", &(&2 <> &1.letter))
  end

end
