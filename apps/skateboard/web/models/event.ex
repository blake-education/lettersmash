defmodule Skateboard.Event do
  use Skateboard.Web, :model

  schema "events" do
    field :user_id, :integer
    field :game_id, :string
    field :score, :integer
    field :winner, :boolean, default: false

    timestamps
  end

  @required_fields ~w(user_id game_id score winner)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
