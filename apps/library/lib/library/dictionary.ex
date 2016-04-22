defmodule Library.Dictionary do
  use GenServer

  def start_link(state, opts \\ []) do
    {:ok, dictionary} = GenServer.start(__MODULE__, state, opts)
  end

  def check_word(word) do
    GenServer.call(:dictionary, {:check_word, String.downcase(word)})
  end

  ### Server callbacks

  def init([]) do
    {:ok, words} = File.read("/usr/share/dict/words")
    {:ok, format_words(words)}
  end

  defp format_words(words) do
    words
    |> String.downcase
    |> String.split("\n")
  end

  def handle_call({:check_word, word}, _from, dictionary) do
    {:reply, validity(dictionary, word), dictionary}
  end

  defp validity(dictionary, word) do
    cond do
      Enum.member?(dictionary, word) -> {:valid, word}
      true -> {:invalid, word}
    end
  end
end
