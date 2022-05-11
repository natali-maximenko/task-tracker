defmodule TaskTracker.Kafka.Consumer do
  use Broadway

  require Logger
  alias Broadway.Message
  alias TaskTracker.Accounts

  def start_link(_opts) do
    topics = Application.get_env(:task_tracker, :kafka_topics)
    group_id = Application.get_env(:task_tracker, :kafka_group_id)
    brokers = Application.get_env(:task_tracker, :kafka_brokers)
    Broadway.start_link(__MODULE__,
      name: __MODULE__,
      producer: [
        module:
          {BroadwayKafka.Producer,
           [
             hosts: brokers,
             group_id: group_id,
             topics: topics
           ]},
        concurrency: 1
      ],
      processors: [
        default: [
          concurrency: 10
        ]
      ],
      context: %{
        kafka_topics: topics,
        group_id: group_id
      },
      batchers: [
        default: [
          batch_size: 100,
          batch_timeout: 200,
          concurrency: 10
        ]
      ]
    )
  end

  # callbacks

  @impl true
  def handle_message(_processor, %Message{data: data, metadata: %{topic: "accounts-stream"}} = message, context) do
    Logger.debug("BROADWAY #{inspect(context, pretty: true)}\n#{inspect(message, pretty: true)}")

    case Jason.decode(data) do
      {:ok, payload} ->
        IO.inspect(payload)
        # TODO find or create
        {:ok, user} = Accounts.create_user(payload["data"])
        IO.inspect(user)

      err ->
        Logger.error(
          "Unable to decode kafka message, context: #{inspect(context)}, error: #{inspect(err, pretty: true)}, message:\n#{inspect(message, pretty: true)}"
        )
    end

    message
  end

  @impl true
  def handle_message(_processor, %Message{data: data, metadata: %{topic: topic}} = message, context) do
    Logger.debug("BROADWAY #{inspect(context, pretty: true)}\n#{inspect(message, pretty: true)}")

    case Jason.decode(data) do
      {:ok, payload} ->
        IO.puts(topic)
        IO.inspect(payload)

      err ->
        Logger.error(
          "Unable to decode kafka message, context: #{inspect(context)}, error: #{inspect(err, pretty: true)}, message:\n#{inspect(message, pretty: true)}"
        )
    end

    message
  end

  @impl true
  def handle_batch(_, messages, _, _) do
    list = messages |> Enum.map(fn e -> e.data end)
    IO.inspect(list, label: "Got batch")
    messages
  end
end
