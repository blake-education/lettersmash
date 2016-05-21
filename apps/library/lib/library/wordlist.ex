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
  add a word and player to the list
  """
  def add(pid, word, player) do
    GenServer.cast(pid, {:add, word, player})
  end

  @doc """
  clears the list
  """
  def clear(pid) do
    GenServer.cast(pid, :clear)
  end

  def init(:ok) do
    {:ok, [] }
  end

  def handle_call(:words, _from, state) do
    {:reply, state, state}
  end

  def handle_call({:played?, word}, _from, state) do
    w = Enum.reduce(word, "", &(&2 <> &1.letter))
    played = Enum.any?(state, &(&1.word == w))
    {:reply, played, state}
  end

  def handle_cast({:add, word, player}, state) do
    w = Enum.reduce(word, "", &(&2 <> &1.letter))
    {:noreply, List.insert_at(state, 0, %{word: w, played_by: player.index})}
  end

  def handle_cast(:clear, state) do
    {:noreply, []}
  end

end
