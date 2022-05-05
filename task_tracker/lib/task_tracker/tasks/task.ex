defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :employee_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:description, :employee_id])
    |> validate_required([:description, :employee_id])
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
