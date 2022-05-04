defmodule TaskTracker.TasksTest do
  use TaskTracker.DataCase

  alias TaskTracker.Tasks

  describe "tasks" do
    alias TaskTracker.Tasks.Task

    import TaskTracker.TasksFixtures

    @invalid_attrs %{completed: nil, description: nil, employee_id: nil}

    test "list_tasks/0 returns all tasks" do
      task = task_fixture()
      assert Tasks.list_tasks() == [task]
    end

    test "get_task!/1 returns the task with given id" do
      task = task_fixture()
      assert Tasks.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      valid_attrs = %{description: "some description", employee_id: "7488a646-e31f-11e4-aace-600308960662"}

      assert {:ok, %Task{} = task} = Tasks.create_task(valid_attrs)
      assert task.completed == false
      assert task.description == "some description"
      assert task.employee_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Tasks.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      task = task_fixture()
      update_attrs = %{completed: false, description: "some updated description", employee_id: "7488a646-e31f-11e4-aace-600308960668"}

      assert {:ok, %Task{} = task} = Tasks.update_task(task, update_attrs)
      assert task.completed == false
      assert task.description == "some updated description"
      assert task.employee_id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_task/2 with invalid data returns error changeset" do
      task = task_fixture()
      assert {:error, %Ecto.Changeset{}} = Tasks.update_task(task, @invalid_attrs)
      assert task == Tasks.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      task = task_fixture()
      assert {:ok, %Task{}} = Tasks.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Tasks.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      task = task_fixture()
      assert %Ecto.Changeset{} = Tasks.change_task(task)
    end
  end
end
