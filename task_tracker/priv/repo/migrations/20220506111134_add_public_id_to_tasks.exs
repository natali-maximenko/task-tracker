defmodule TaskTracker.Repo.Migrations.AddPublicIdToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :public_id, :uuid
    end
  end
end
