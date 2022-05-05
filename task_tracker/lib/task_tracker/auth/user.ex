defmodule TaskTracker.Auth.User do
  use Ecto.Schema

  embedded_schema do
    field :email, :string
    field :role, :string
    field :public_id, Ecto.UUID
  end
end
