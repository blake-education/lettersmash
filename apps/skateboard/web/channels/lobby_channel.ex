defmodule Skateboard.LobbyChannel do
  use Phoenix.Channel
  alias Library.GameServer

  def join("lobby", _message, socket) do
    IO.puts "join lobby"
    {:ok, socket}
  end

  def handle_in("game_list", payload, socket) do
    IO.puts "lobby game_list"
    IO.puts "lobby game_list payload"
    IO.inspect payload
    names = GameServer.game_names()
    games = Enum.map(names, fn(name) -> %{name: name} end)
    IO.puts "lobby game_list games"
    IO.inspect games
    push(socket, "games", %{games: games})
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("new_game", payload, socket) do
    IO.puts "lobby new_game"
    #GameServer.add_game(socket.assigns.game_name)
    GameServer.add_game("test")
    names = GameServer.game_names()
    games = Enum.map(names, fn(name) -> %{name: name} end)
    push(socket, "games", %{games: games})
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("join_game", payload, socket) do
    IO.puts "lobby join_game"
    IO.inspect payload
    #GameServer.add_game("test")
    #push(socket, "games", %{games: GameServer.game_names})
    {:reply, {:ok, %{name: payload}}, socket}
  end

end
