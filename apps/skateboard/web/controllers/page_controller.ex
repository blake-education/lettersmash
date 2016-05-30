defmodule Skateboard.PageController do
  use Skateboard.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def lobby(conn, _params) do
    render conn, "lobby.html"
  end

  def game(conn, _params) do
    render conn, "game.html"
  end
end
