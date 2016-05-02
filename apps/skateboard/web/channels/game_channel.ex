defmodule Skateboard.GameChannel do
  use Phoenix.Channel
  alias Skateboard.User
  alias Library.Game
  alias Library.Dictionary

  def join("game:new", _message, socket) do
    id = socket.assigns.user_id
    user = Skateboard.Repo.get(User, id)

    game = :current_game
    user_map = %{id: user.id, name: user.name, score: 0}
    Game.add_player(game, user_map)

    {:ok, assign(socket, :game, game)}
  end

  def handle_in("board_state", payload, socket) do
    game = socket.assigns.game
    push(socket, "board_state", Game.display_state(game))

    {:reply, {:ok, payload}, socket}
  end

  def handle_in("submit_word", letters, socket) do
    {validity, _} = Dictionary.check_word word(letters)
    case validity do
      :invalid ->
        push(socket, "submission_failed", %{})
      :valid ->
        game = socket.assigns.game
        Game.submit_word(game, letters, socket.assigns.user_id)
        push(socket, "submission_successful", %{})
        broadcast!(socket, "board_state", Game.display_state(game))
    end

    {:reply, :ok, socket}
  end

  defp word(letters) do
    Enum.reduce(letters, "", &(&2 <> &1["letter"]))
  end

  def terminate(_message, socket) do
    id = socket.assigns.user_id
    user = Skateboard.Repo.get(User, id)
    user_map = %{id: user.id, name: user.name, score: 0}

    game = socket.assigns.game
    Game.remove_player(game, user_map)

    {:reply, :ok, socket}
  end

end
