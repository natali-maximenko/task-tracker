defmodule TaskTracker.Commands.ShuffleTasks do
  @moduledoc """
  Команда переназначает открытые таски на пользователей.
  """
  import Ecto.Query, warn: false
  alias TaskTracker.{Auth, Repo, Tasks}
  alias TaskTracker.Kafka.Producer
  alias TaskTracker.SchemaRegistry

  def call(token) do
    task_ids = Tasks.list_opened_tasks()
    {:ok, user_ids} = Auth.list_employee_ids(token)

    task_ids
    |> shuffle(user_ids)
    |> update_all()
  end

  defp shuffle(tasks, users) do
    for t <- tasks, do: {t, Enum.random(users)}
  end

  defp update_all(pairs) do
    Enum.each(pairs, fn {task_id, user_id} ->
      from(t in Tasks.Task, where: t.id == ^task_id)
      |> Repo.update_all(set: [employee_id: user_id])

      # TODO use batch produce
      produce(%{task_id: task_id, employee_id: user_id})
    end)
  end

  @assign_schema SchemaRegistry.load_schema("tasks", "task_assigned")
  defp produce(data) do
    event = %{
      "event_id" => Ecto.UUID.generate,
      "event_version" => 1,
      "event_time" => DateTime.now!("Etc/UTC") |> to_string(),
      "event_name" => "task_assigned",
      "producer" => "task_tracker",
      "data" => data}
    :ok = SchemaRegistry.validate(@assign_schema, event)
    Producer.send_message("tasks-lifecycle", event)
  end
end
