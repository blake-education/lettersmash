defmodule Library.GameServer do

  @moduledoc """
  A supervisor for starting games
  """

  use Supervisor
  alias Library.Game

  def add_game(name) do
    Supervisor.start_child(__MODULE__, [name])
  end

  def delete_game(game) do
    Supervisor.terminate_child(__MODULE__, game)
  end

  def find_game(name) do
    IO.inspect games
    Enum.find games, fn(child) ->
      IO.puts "#{Game.name(child)} == #{name}"
      Game.name(child) == name
    end
  end

  def games do
    __MODULE__
    |> Supervisor.which_children
    |> Enum.map(fn({_, child, _, _}) -> child end)
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


