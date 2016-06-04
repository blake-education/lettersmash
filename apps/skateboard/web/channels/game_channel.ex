defmodule Skateboard.GameChannel do
  use Phoenix.Channel
  alias Skateboard.{Repo,User}
  alias Library.{GameServer,Game}

  def join("game:" <> name, _message, socket) do
    IO.puts "joining game #{name}"
    game = find_or_create_game(name)
    socket = assign(socket, :game_name, name)

    id = socket.assigns.user_id
    user = Repo.get(User, id)
    user_map = %{id: user.id, name: user.name}
    Game.add_player(game, user_map)
    send(self, :after_join)
    {:ok, socket}
  end

  def handle_in("board_state", payload, socket) do
    game = find_or_create_game(socket.assigns.game_name)
    state = Game.display_state(game)
    push(socket, "board_state", state)
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("submit_word", letters, socket) do
    game = find_or_create_game(socket.assigns.game_name)
    case Game.submit_word(game, atomize(letters), socket.assigns.user_id) do
      {:error, reason} ->
        push(socket, "submission_failed", %{message: reason})
      _ ->
        broadcast_state(socket)
        push(socket, "submission_successful", %{message: "success!"})
    end
    {:reply, :ok, socket}
  end

  def handle_in("new_board", payload, socket) do
    game = find_or_create_game(socket.assigns.game_name)
    Game.new_board(game)
    broadcast_state(socket)
    {:reply, {:ok, payload}, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast_state(socket)
    {:noreply, socket}
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp broadcast_state(socket) do
    game = find_or_create_game(socket.assigns.game_name)
    broadcast!(socket, "board_state", Game.display_state(game))
  end

  defp find_or_create_game(name) do
    game = GameServer.find_game name
    IO.inspect game
    unless game do
      IO.puts "game not found"
      {:ok, game} = GameServer.add_game(name)
    end
    IO.inspect game
    game
  end

  defp atomize(word) do
    word
    |> Enum.map(fn(letter) ->
      for {key, val} <- letter, into: %{}, do: {String.to_atom(key), val}
    end)
  end

end
