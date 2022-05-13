defmodule TaskTrackerWeb.TaskController do
  use TaskTrackerWeb, :controller

  alias TaskTracker.Tasks
  alias TaskTracker.Tasks.Task
  alias TaskTracker.Kafka.Producer
  alias TaskTracker.Commands.{AddTask, CompleteTask, ShuffleTasks}
  alias TaskTracker.SchemaRegistry

  def index(conn, _params) do
    tasks = Tasks.list_tasks()
    render(conn, "index.html", tasks: tasks)
  end

  def new(conn, _params) do
    changeset = Tasks.change_task(%Task{})
    render(conn, "new.html", changeset: changeset)
  end

  @assign_schema SchemaRegistry.load_schema("tasks", "task_assigned")
  def create(conn, %{"task" => task_params}) do
    case AddTask.call(Guardian.Plug.current_token(conn), task_params) do
      {:ok, task} ->
        data = %{"description" => task.description, "public_id" => task.public_id, "employee_id" => task.employee_id, "completed" => task.completed}
        event = %{
          "event_id" => Ecto.UUID.generate,
          "event_version" => 1,
          "event_time" => DateTime.now!("Etc/UTC") |> to_string(),
          "event_name" => "task_assigned",
          "producer" => "task_tracker",
          "data" => data}
        :ok = SchemaRegistry.validate(@assign_schema, event)
        Producer.send_message("tasks-lifecycle", event)

        conn
        |> put_flash(:info, "Task created successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    render(conn, "show.html", task: task)
  end

  def edit(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    changeset = Tasks.change_task(task)
    render(conn, "edit.html", task: task, changeset: changeset)
  end

  def update(conn, %{"id" => id, "task" => task_params}) do
    task = Tasks.get_task!(id)

    case Tasks.update_task(task, task_params) do
      {:ok, task} ->
        conn
        |> put_flash(:info, "Task updated successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  @complete_schema SchemaRegistry.load_schema("tasks", "task_completed")
  def complete(conn, %{"id" => id}) do
    case CompleteTask.call(id) do
      {:ok, task} ->
        data = %{public_id: task.public_id, employee_id: task.employee_id}
        event = %{
          "event_id" => Ecto.UUID.generate,
          "event_version" => 1,
          "event_time" => DateTime.now!("Etc/UTC") |> to_string(),
          "event_name" => "task_completed",
          "producer" => "task_tracker",
          "data" => data}
        :ok = SchemaRegistry.validate(@complete_schema, event)
        Producer.send_message("tasks-lifecycle", event)

        conn
        |> put_flash(:info, "Tasks completed successfully.")
        |> redirect(to: Routes.task_path(conn, :show, task))

      {:error, %Ecto.Changeset{} = changeset} ->
        task = Tasks.get_task!(id)
        render(conn, "edit.html", task: task, changeset: changeset)
    end
  end

  def shuffle(conn, _) do
    Guardian.Plug.current_token(conn) |> ShuffleTasks.call()

    conn
    |> put_flash(:info, "Task shuffle completed.")
    |> redirect(to: Routes.task_path(conn, :index))
  end

  def delete(conn, %{"id" => id}) do
    task = Tasks.get_task!(id)
    {:ok, _task} = Tasks.delete_task(task)

    conn
    |> put_flash(:info, "Task deleted successfully.")
    |> redirect(to: Routes.task_path(conn, :index))
  end
end
