defmodule Library.GameServer do

  @moduledoc """
  A supervisor for starting games
  """

  use Supervisor
  alias Library.Game

  @doc """
  starts a Game
  """
  def add_game(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  @doc """
  deletes a Game
  """
  def delete_game(game) do
    Supervisor.terminate_child(__MODULE__, game)
  end

  @doc """
  finds a Game by name
  """
  def find_game(name) do
    Enum.find games, fn(child) ->
      Game.name(child) == name
    end
  end

  @doc """
  returns all Games
  """
  def games do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({_, child, _, _}) -> child end)
  end

  @doc """
  returns all Games
  """
  def game_names do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({_, child, _, _}) -> Game.name(child) end)
  end

  ###
  # Supervisor API
  ###

  def start_link do
    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def init(_) do
    children = [
      worker(Game, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end


