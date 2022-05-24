defmodule Billing.Repo.Migrations.CreateAuditLogs do
  use Ecto.Migration

  def change do
    create table(:audit_logs) do
      add :description, :string
      add :employee_id, :uuid
      add :debit, :integer
      add :credit, :integer

      timestamps()
    end
  end
end
