defmodule TaskTracker.TasksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskTracker.Tasks` context.
  """

  @doc """
  Generate a task.
  """
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        completed: true,
        description: "some description",
        employee_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> TaskTracker.Tasks.create_task()

    task
  end
end
