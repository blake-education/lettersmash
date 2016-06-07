defmodule Skateboard.LobbyChannel do
  use Phoenix.Channel
  alias Library.GameServer

  def join("lobby", _message, socket) do
    IO.puts "join lobby"
    {:ok, socket}
  end

  def handle_in("game_list", payload, socket) do
    broadcast!(socket, "games", %{games: GameServer.stats})
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_game", payload, socket) do
    GameServer.add_game("test")
    broadcast!(socket, "games", %{games: GameServer.stats})
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("join_game", payload, socket) do
    #GameServer.add_game("test")
    #push(socket, "games", %{games: GameServer.game_names})
    {:reply, {:ok, %{name: payload}}, socket}
  end

end
