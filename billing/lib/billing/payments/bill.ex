defmodule Billing.Payments.Bill do
  use Ecto.Schema
  import Ecto.Changeset

  schema "bills" do
    field :balance, :integer, default: 0
    field :employee_id, Ecto.UUID

    timestamps()
  end

  @fields [:balance, :employee_id]

  @doc false
  def changeset(bill, attrs) do
    bill
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end

  def update_changeset(bill, attrs) do
    bill
    |> cast(attrs, [:balance])
    |> validate_required([:balance])
  end
end
