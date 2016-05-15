defmodule Library.GameSup do
  @moduledoc """
  A supervisor for starting games
  """

  use Supervisor
  alias Library.Game

  def add_game(game_name) do
    Supervisor.start_child(__MODULE__, [game_name])
  end

  # [g] Might use this approach to send a message (with all the games)
  #     back to the phoenix channel that is creating the game.
  def add_game(pid, game_name) when is_pid(pid) do
    with {:ok, pid} <- Supervisor.start_child(__MODULE__, [game_name]),
         do: send(pid, {:all_games, games})
  end

  def delete_game(game_name) do
    Supervisor.terminate_child(__MODULE__, game_name)
  end

  def find_game(game_name) do
    Enum.find games, fn(child) ->
      Game.name(child) == game_name
    end
  end

  def games do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({_, pid, _, _}) -> Game.name(pid) end)
  end

  ###
  # Supervisor API
  ###
  def start_link do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    [worker(Game, [])] |> supervise(strategy: :simple_one_for_one)
  end
end
