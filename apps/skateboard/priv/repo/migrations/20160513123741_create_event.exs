defmodule Skateboard.Repo.Migrations.CreateEvent do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :user_id, :integer
      add :game_id, :integer
      add :score, :integer
      add :winner, :boolean, default: false

      timestamps
    end

  end
end
