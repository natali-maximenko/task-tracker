defmodule Billing.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks) do
      add :public_id, :uuid, null: false
      add :description, :string
      add :employee_id, :uuid
      add :assign_price, :integer
      add :complete_price, :integer
      add :completed, :boolean, default: false, null: false

      timestamps()
    end
  end
end
