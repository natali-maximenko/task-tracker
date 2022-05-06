defmodule TaskTracker.Commands.AddTask do
  @moduledoc """
  Добавление задачи в систему
  """
  alias TaskTracker.Auth
  alias TaskTracker.Tasks

  def call(token, task_params) do
    with {:ok, employee_id} <- Auth.get_employee_id(token),
         attrs <- Map.merge(task_params, %{"employee_id" => employee_id}) do
      Tasks.create_task(attrs)
    end
  end
end
