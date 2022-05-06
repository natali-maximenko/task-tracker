# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :task_tracker,
  ecto_repos: [TaskTracker.Repo]

# Configures the endpoint
config :task_tracker, TaskTrackerWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: TaskTrackerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: TaskTracker.PubSub,
  live_view: [signing_salt: "Ocy066wO"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :task_tracker, TaskTracker.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configure esbuild (the version is required)
config :esbuild,
  version: "0.14.29",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :task_tracker, TaskTracker.Auth.Guardian,
  issuer: "task_tracker",
  secret_key: "1rxopZpgejcVlr4luT+N9K6ZE6Z187Wx4yZTCDx3AgSHc7HyIerz+MYJo1J6wFrv",
  ttl: {1, :days}

config :task_tracker,
  auth_host: "http://localhost:4000",
  auth_endpoint: "/api/v1/users/log_in",
  auth_get_employee: "/api/v1/users/random_employee_id"

topics = ["test", "tasks", "tasks-stream"]

config :task_tracker,
  kafka_topics: topics,
  kafka_group_id: "group_1",
  kafka_brokers: [kafka: 9092]

config :kafka_ex,
  brokers: "kafka:9092",
  topics: topics,
  disable_default_worker: true,
  kafka_version: "kayrock",
  sleep_for_reconnect: 5_000

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
