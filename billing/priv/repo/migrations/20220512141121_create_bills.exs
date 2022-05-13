defmodule Billing.Repo.Migrations.CreateBills do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add :balance, :integer, default: 0
      add :employee_id, :uuid, null: false

      timestamps()
    end
  end
end
