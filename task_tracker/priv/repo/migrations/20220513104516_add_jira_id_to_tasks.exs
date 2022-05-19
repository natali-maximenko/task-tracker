defmodule TaskTracker.Repo.Migrations.AddJiraIdToTasks do
  use Ecto.Migration

  def change do
    alter table(:tasks) do
      add :jira_id, :string
    end
  end
end
