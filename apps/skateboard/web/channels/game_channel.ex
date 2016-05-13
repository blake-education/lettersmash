defmodule Skateboard.GameChannel do
  use Phoenix.Channel
  alias Skateboard.User
  alias Skateboard.Event
  alias Skateboard.Repo
  alias Library.Game

  def join("game:new", _message, socket) do
    id = socket.assigns.user_id
    user = Skateboard.Repo.get(User, id)

    game = :current_game
    user_map = %{id: user.id, name: user.name, score: 0}
    Game.add_player(game, user_map)
    send(self, :after_join)

    {:ok, assign(socket, :game, game)}
  end

  def handle_in("board_state", payload, socket) do
    game = socket.assigns.game
    push(socket, "board_state", Game.display_state(game))

    {:reply, {:ok, payload}, socket}
  end

  def handle_in("submit_word", letters, socket) do
    game = socket.assigns.game
    case Game.submit_word(game, atomize(letters), socket.assigns.user_id) do
      {:error, reason} ->
        push(socket, "submission_failed", %{message: reason})
      _ ->
        broadcast!(socket, "board_state", Game.display_state(game))
        push(socket, "submission_successful", %{message: "success!"})
        if Game.finished(game) do
          save_events(Game.players(game))
        end

    end
    {:reply, :ok, socket}
  end

  def handle_in("new_game", payload, socket) do
    game = socket.assigns.game
    Game.new_game(game)
    broadcast!(socket, "board_state", Game.display_state(game))
    {:reply, {:ok, payload}, socket}
  end

  def handle_info(:after_join, socket) do
    broadcast!(socket, "board_state", Game.display_state(socket.assigns.game))
    {:noreply, socket}
  end

  def handle_info(_, socket) do
    {:noreply, socket}
  end

  defp atomize(word) do
    word
    |> Enum.map(fn(letter) ->
      for {key, val} <- letter, into: %{}, do: {String.to_atom(key), val}
    end)
  end

  defp save_events(players) do
    players
    |> Enum.map(fn(player) ->
      save_player(player)
    end)
  end

  defp save_player(player) do
    Repo.insert(%Event{
      user_id: player.id,
      game_id: 1,
      score: player.score,
      winner: false
    })
  end

end
