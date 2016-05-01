defmodule Library.Game do
  use GenServer
  alias Library.Board

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
        board: Board.generate,
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

    new_board = Board.add_word(atomize_word(word), player, board_state.board)
    new_state = %{board_state | board: new_board}

    {:reply, :ok, new_state}
  end

  def handle_call(:list_state, _from, board_state) do
    {:reply, board_state, board_state}
  end

  def handle_call(:display_state, _from, board_state) do
    board = board_state.board
    |> Board.surrounded
    |> Enum.chunk(5)
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

  defp atomize_word(word) do
    word
    |> Enum.map(fn(letter) ->
      for {key, val} <- letter, into: %{}, do: {String.to_atom(key), val}
    end)
  end

end
