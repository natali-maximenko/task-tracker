defmodule TaskTracker.Commands.CompleteTask do
  @moduledoc """
  Команда завершения задачи
  """
  alias TaskTracker.Tasks

  def call(task_id) do
    task_id
    |> Tasks.get_task!()
    |> Tasks.complete_task()
  end
end
