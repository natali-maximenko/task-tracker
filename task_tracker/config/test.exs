import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :task_tracker, TaskTracker.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "task_tracker_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :task_tracker, TaskTrackerWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "3PxeC/rRVl8y7f6/DWAYbuz1mLcaPAhW4NoKL47oKl16RgPPLt65klb8YcuPem5F",
  server: false

# In test we don't send emails.
config :task_tracker, TaskTracker.Mailer, adapter: Swoosh.Adapters.Test

config :task_tracker, Oban, testing: :inline

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
