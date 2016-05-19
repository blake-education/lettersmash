defmodule Skateboard.GameChannel do
  use Phoenix.Channel
  alias Skateboard.Repo
  alias Skateboard.User
  alias Library.Game

  def join("game:" <> name, _message, socket) do
    IO.puts "joining game:#{name}"
    game = find_or_create_game(name)
    socket = assign(socket, :game_name, name)
    socket = assign(socket, :game, game)

    id = socket.assigns.user_id
    user = Repo.get(User, id)
    user_map = %{id: user.id, name: user.name}
    Game.add_player(game, user_map)
    send(self, :after_join)
    IO.inspect socket.assigns

    {:ok, socket}
  end

  def handle_in("board_state", payload, socket) do

    game = socket.assigns.game
    {:ok, state} = Game.display_state(socket.assigns.game)
    push(socket, "board_state", state)

    {:reply, {:ok, payload}, socket}
  end

  def handle_in("submit_word", letters, socket) do
    game = socket.assigns.game
    case Game.submit_word(game, atomize(letters), socket.assigns.user_id) do
      {:error, reason} ->
        push(socket, "submission_failed", %{message: reason})
      _ ->
        broadcast_state(socket)
        push(socket, "submission_successful", %{message: "success!"})
    end
    {:reply, :ok, socket}
  end

  def handle_in("new_game", payload, socket) do
    game = socket.assigns.game
    Game.new_game(game)
    broadcast_state(socket)
    {:reply, {:ok, payload}, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast_state(socket)
    {:noreply, socket}
  end

  defp broadcast_state(socket) do
    game = find_or_create_game(socket.assigns.game_name)
    {:ok, state} = Game.display_state(game)
    broadcast!(socket, "board_state", state)
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp find_game(socket) do
    Library.GameServer.find_game(socket.assigns[:game_name])
  end

  defp find_or_create_game(name) do
    IO.puts "find_or_create_game #{name}"
    game = Library.GameServer.find_game name
    unless game do
      {:ok, game} = Library.GameServer.add_game(name)
    end
    IO.puts "find_or_create_game #{name}"
    game
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
  defp atomize(word) do
    word
    |> Enum.map(fn(letter) ->
      for {key, val} <- letter, into: %{}, do: {String.to_atom(key), val}
    end)
  end

end
