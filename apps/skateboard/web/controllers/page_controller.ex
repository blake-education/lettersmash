defmodule Skateboard.PageController do
  use Skateboard.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
