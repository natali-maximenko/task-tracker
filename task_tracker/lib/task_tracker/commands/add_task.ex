defmodule TaskTracker.Commands.AddTask do
  @moduledoc """
  Добавление задачи в систему
  """
  alias TaskTracker.Auth
  alias TaskTracker.Tasks

  def call(token, task_params) do
    token
    |> Auth.get_employee_id()
    |> assign_employee(task_params)
    |> Tasks.create_task()
  end

  defp assign_employee({:ok, employee_id}, params) do
    Map.merge(params, %{"employee_id" => employee_id})
  end
end
