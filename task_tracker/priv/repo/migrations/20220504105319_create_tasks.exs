defmodule TaskTracker.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :description, :string
      add :employee_id, :uuid
      add :completed, :boolean, default: false, null: false

      timestamps()
    end
  end
end
