defmodule Billing.Payments.AuditLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "audit_logs" do
    field :credit, :integer, default: 0
    field :debit, :integer, default: 0
    field :description, :string
    field :employee_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(audit_log, attrs) do
    audit_log
    |> cast(attrs, [:description, :employee_id, :debit, :credit])
    |> validate_required([:description, :employee_id])
  end
end
