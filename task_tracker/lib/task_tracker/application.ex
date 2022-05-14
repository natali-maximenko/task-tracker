defmodule TaskTracker.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      TaskTracker.Repo,
      # Start the Telemetry supervisor
      TaskTrackerWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: TaskTracker.PubSub},
      # Start the Endpoint (http/https)
      TaskTrackerWeb.Endpoint,
      # Kafka
      {TaskTracker.Kafka.Consumer, []},
      {Oban, oban_config()}
      # Start a worker by calling: TaskTracker.Worker.start_link(arg)
      # {TaskTracker.Worker, arg}
    ]

    KafkaEx.create_worker(:kafka_producer)

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: TaskTracker.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    TaskTrackerWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp oban_config do
    Application.fetch_env!(:task_tracker, Oban)
  end
end
