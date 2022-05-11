defmodule TaskTracker.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:users) do
      add :email, :citext, null: false
      add :name, :string
      add :role, :string, null: false
      add :public_id, :uuid, null: false

      timestamps()
    end
  end
end
