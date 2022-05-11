defmodule Billing.Repo do
  use Ecto.Repo,
    otp_app: :billing,
    adapter: Ecto.Adapters.Postgres
end
