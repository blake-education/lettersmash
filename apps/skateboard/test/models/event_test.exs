defmodule Skateboard.EventTest do
  use Skateboard.ModelCase

  alias Skateboard.Event

  @valid_attrs %{game_id: 42, score: 42, user_id: 42, winner: true}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Event.changeset(%Event{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Event.changeset(%Event{}, @invalid_attrs)
    refute changeset.valid?
  end
end
