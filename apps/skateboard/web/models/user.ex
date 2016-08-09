defmodule Skateboard.User do
  use Skateboard.Web, :model

  schema "users" do
    field :name, :string
    field :crypted_password, :string
    field :password, :string, virtual: true
    timestamps
  end

  @required_fields ~w(name password)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name)
  end
end
