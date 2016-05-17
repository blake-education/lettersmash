defmodule Skateboard.RegistrationControllerTest do
  use Skateboard.ConnCase

  setup do
    user = insert_user(name: "Test", password: "Password")
    conn = assign(conn(), :current_user, user)
    {:ok, conn: conn, user: user}
  end

  test "allows users to register", %{conn: conn} do
    conn = post conn, "/registrations", %{user: %{name: "New", password: "Password"}}
    assert redirected_to(conn) == page_path(conn, :index)
    assert length(Skateboard.Repo.all(Skateboard.User)) == 2
  end

  test "does not allow users to register with an existing name", %{conn: conn} do
    conn = post conn, "/registrations", %{user: %{name: "Test", password: "Password"}}
    assert html_response(conn, 200) =~ "Name has already been taken"
  end
end
