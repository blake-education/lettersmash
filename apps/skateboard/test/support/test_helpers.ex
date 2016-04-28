defmodule Skateboard.TestHelpers do
  alias Skateboard.Repo
  alias Skateboard.User

  def insert_user(attrs \\ %{}) do
    changes = Dict.merge(%{
      name: "name",
      password: "password"
    }, attrs)
    changeset = User.changeset(%User{}, changes)    
    Skateboard.Registration.create(changeset, Repo)
  end
end
