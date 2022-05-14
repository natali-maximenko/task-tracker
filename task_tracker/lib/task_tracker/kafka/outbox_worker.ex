defmodule TaskTracker.Kafka.OutboxWorker do
  @moduledoc """
  Реализует transactional outbox для отправки сообщений
  """
  use Oban.Worker,
    queue: :events,
    max_attempts: 3,
    tags: ["tasks-lifecycle"]

  alias TaskTracker.Kafka.Producer
  alias TaskTracker.SchemaRegistry

  @impl Oban.Worker
  def perform(%Oban.Job{args: %{"event_name" => event_name, "event_version" => version} = event}) do
    with schema <- SchemaRegistry.load_schema("tasks",  event_name, version),
      :ok <- SchemaRegistry.validate(schema, event_name) do
      Producer.send_message("tasks-lifecycle", event)
    end

    :ok
  end
end
