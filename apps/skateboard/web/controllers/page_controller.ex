defmodule Skateboard.PageController do
  use Skateboard.Web, :controller

  def index(conn, _params) do
    IO.inspect conn.assigns
    if conn.assigns.current_user do
      redirect(conn, to: page_path(conn, :game))
    else
      render conn, "index.html"
    end
  end

  def game(conn, _params) do
    render conn, "game.html"
  end
end
