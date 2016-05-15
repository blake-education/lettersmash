defmodule Skateboard.Repo.Migrations.ChangeGameIdToString do
  use Ecto.Migration

  def change do
    alter table(:events) do
      modify :game_id, :string
    end
  end
end
