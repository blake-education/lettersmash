defmodule Skateboard.SessionControllerTest do
  use Skateboard.ConnCase

  setup do
    user = insert_user(name: "Test", password: "Password")
    conn = assign(conn(), :current_user, user)
    {:ok, conn: conn, user: user}
  end

  test "allows users to log in", %{conn: conn} do
    conn = post conn, "/login", %{session: %{name: "Test", password: "Password"}}
    assert redirected_to(conn) == page_path(conn, :game)
  end

  test "does not allow users to sign in with invalid details", %{conn: conn} do
    conn = post conn, "/login", %{session: %{name: "Test", password: "Invalid"}}
    assert html_response(conn, 200) =~ "Wrong name or password"
  end
end
