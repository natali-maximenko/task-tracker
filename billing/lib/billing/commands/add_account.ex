defmodule Billing.Commands.AddAccount do
  @moduledoc """
  Добавляет клиента в систему
  """
  alias Billing.{Accounts, Payments}

  def call(attrs) do
    attrs
    |> Accounts.create_user()
    |> Payments.create_bill()
  end
end
