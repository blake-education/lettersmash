defmodule Library.Dictionary do

  @moduledoc """
  contains functions for determining if a word is valid
  """
  use GenServer

  def start_link(state, opts \\ []) do
    {:ok, _} = GenServer.start(__MODULE__, state, opts)
  end

  def invalid?(word) do
    GenServer.call(:dictionary, {:invalid?, word})
  end

  ### Server callbacks

  def init([]) do
    with {:ok, words} <- File.read("./apps/library/lib/library/sowpods.txt"),
      do: {:ok, format_words(words)}
  end

  defp format_words(words) do
    words
    |> String.downcase
    |> String.split("\n")
  end

  def handle_call({:invalid?, word}, _from, dictionary) do
    w = word
    |> Enum.reduce("", &(&2 <> &1.letter))
    |> String.downcase
    {:reply, !Enum.member?(dictionary, w), dictionary}
  end

end
