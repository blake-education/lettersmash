defmodule Skateboard.GameChannel do
  use Phoenix.Channel
  alias Skateboard.User

  def join("game:new", _message, socket) do
    id = socket.assigns.user_id
    user = Skateboard.Repo.get(User, id)
    {:ok, %{user_id: user.id, user_name: user.name}, socket}
  end
end
