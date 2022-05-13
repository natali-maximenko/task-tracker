# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :billing,
  ecto_repos: [Billing.Repo]

# Configures the endpoint
config :billing, BillingWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: BillingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Billing.PubSub,
  live_view: [signing_salt: "1FbasD0n"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :billing, Billing.Mailer, adapter: Swoosh.Adapters.Local

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

config :billing, Billing.Auth.Guardian,
  issuer: "billing",
  secret_key: "1rxopZpgejcVlr4luT+N9K6ZE6Z187Wx4yZTCDx3AgSHc7HyIerz+MYJo1J6wFrv",
  ttl: {1, :days}

config :billing,
  auth_host: "http://localhost:4000",
  auth_endpoint: "/api/v1/users/log_in"

consumer_topics = ["accounts-stream", "tasks-lifecycle"]

config :billing,
  kafka_topics: consumer_topics,
  kafka_group_id: "group_1",
  kafka_brokers: [kafka: 9092]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
