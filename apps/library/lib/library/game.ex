defmodule Library.Game do
  use GenServer
  @number_of_letters 25
  @generator Library.LetterGenerator

  @moduledoc """

    _Example_
    iex> Library.Game.add_player(pid, %{id: 1, name: "abc"})
    :ok
    iex> Library.Game.list_state(pid)
    %{board: [], players: [%{id: 1, name: "abc"}]}
    iex> Library.Game.add_player(pid, %{id: 2, name: "dododo"})
    :ok
    iex> Library.Game.list_state(pid)
    %{board: [], players: [%{id: 1, name: "abc"}, %{id: 2, name: "dododo"}]}
    iex> Library.Game.remove_player(pid, %{id: 2})
    :ok
    iex> Library.Game.list_state(pid)
    %{board: [], players: [%{id: 1, name: "abc"}]}
  """

  def start_link, do: GenServer.start_link(__MODULE__, :ok, name: :current_game)

  def submit_word(pid, word, player) do
    GenServer.call(pid, {:submit_word, word, player})
  end

  def add_player(pid, player) do
    GenServer.cast(pid, {:add_player, player})
  end

  def remove_player(pid, player) when is_map(player) do
    GenServer.cast(pid, {:remove_player, player})
  end

  def display_state(pid), do: GenServer.call(pid, :display_state)
  def list_state(pid), do: GenServer.call(pid, :list_state)

  def init(:ok) do
    {
      :ok,
      %{
        board: build_board,
        players: [],
        next_index: 1
      }
    }
  end

  def handle_call({:submit_word, word, player}, _from, board_state) do
    # this will delegate out to the dictionary to see if this is a valid word
    #
    # Would love to use this type of system.
    #
    # with {:ok} <- words_consist_of_valid_letters?(word),
    #      {:ok} <- have_not_played_word?(player, word),
    # do:  {:reply, {:ok, word}, board_state}
    # else {:reply, {:error, "word not valid", board_state}}

    if true do
      new_board = Enum.reduce(word, board_state.board, fn(letter, acc) ->
        replace_letter(letter, player, acc)
      end)

      new_state = %{board_state | board: new_board}

      {:reply, :ok, new_state}
    else
      {:reply, {:error, "reason"}, board_state}
    end
  end

  defp replace_letter(letter, player, board) do
    new_letter = %{letter | "owner" => String.to_integer(player)}
    List.replace_at(board, Map.get(letter, "id"), new_letter)
  end

  def handle_call(:list_state, _from, board_state) do
    {:reply, board_state, board_state}
  end

  def handle_call(:display_state, _from, board_state) do
    board = Enum.chunk board_state.board, 5
    display_board = Map.put board_state, :board, board
    {:reply, display_board, board_state}
  end

  def handle_cast({:add_player, player}, board_state) do
    new_player = Map.put_new(player, :index, board_state.next_index)

    {
      :noreply,
      %{
        board_state | players: board_state.players ++ [new_player], next_index: (board_state.next_index + 1)
      }
    }
  end

  def handle_cast({:remove_player, player}, board_state) do
    {
      :noreply,
      %{
        board_state | players: remove_player_from_state(board_state.players, player)
      }
    }
  end

  defp remove_player_from_state(all_players, player) do
    Enum.reject(all_players, &(&1.id == player.id))
  end

  defp build_board do
    @generator.generate(@number_of_letters)
    |> Stream.with_index
    |> Enum.map(fn({letter, index}) ->
      %{id: index, letter: letter, owner: 0}
    end)
  end
end
