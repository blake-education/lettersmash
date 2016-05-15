defmodule Skateboard.LobbyChannel do
  use Skateboard.Web, :channel

  alias Library.GameSup

  def join("lobby", payload, socket) do
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_in("create_game", payload, socket) do
    GameSup.add_game("123")

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast!(socket, "game_list", game_names)
    {:noreply, socket}
  end

  def game_names do
    names = for x <- Library.GameSup.games, do: %{name: x}
    %{games: names}
  end
end
