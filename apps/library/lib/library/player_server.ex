defmodule Library.PlayerServer do

  @moduledoc """
  A supervisor for players
  """

  use Supervisor
  alias Library.Player

  def find_or_create_player(player) do
    p = find_player(player.id)
    unless p do
      {:ok, p} = add_player(player)
    end
    p
  end

  def add_player(player) do
    Supervisor.start_child(__MODULE__, [player])
  end

  def find_player(id) do
    Enum.find players, fn(child) ->
      Player.id(child) == id
    end
  end

  def players do
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
      worker(Library.Player, [], restart: :transient)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end

end
