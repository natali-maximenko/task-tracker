defmodule TaskTracker.Tasks.Task do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tasks" do
    field :completed, :boolean, default: false
    field :description, :string
    field :employee_id, Ecto.UUID
    field :public_id, Ecto.UUID, autogenerate: true
    field :jira_id, :string

    timestamps()
  end

  @doc false
  def changeset(task, attrs) do
    task
    |> cast(attrs, [:jira_id, :description, :employee_id])
    |> validate_required([:jira_id, :description, :employee_id])
    |> validate_format(:description, ~r/[^\[\]]/)
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
