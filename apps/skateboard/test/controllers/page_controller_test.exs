defmodule Skateboard.PageControllerTest do
  use Skateboard.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Login"
  end
end
