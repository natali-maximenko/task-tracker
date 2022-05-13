defmodule Billing.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed, :boolean, default: false
    field :assign_price, :integer
    field :complete_price, :integer
    field :description, :string
    field :employee_id, Ecto.UUID
    field :public_id, Ecto.UUID

    timestamps()
  end

  @fields [:public_id, :description, :employee_id, :completed, :complete_price, :assign_price]

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, @fields)
    |> validate_required(@fields)
  end

  def assign_changeset(task, attrs) do
    task
    |> cast(attrs, [:employee_id])
    |> validate_required([:employee_id])
  end

  def complete_changeset(task, attrs) do
    task
    |> cast(attrs, [:employee_id, :completed])
    |> validate_required([:completed])
  end
end
