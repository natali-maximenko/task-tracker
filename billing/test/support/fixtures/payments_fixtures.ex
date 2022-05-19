defmodule Billing.PaymentsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Billing.Payments` context.
  """

  @doc """
  Generate a audit_log.
  """
  def audit_log_fixture(attrs \\ %{}) do
    {:ok, audit_log} =
      attrs
      |> Enum.into(%{
        credit: 42,
        debit: 42,
        description: "some description",
        employee_id: "7488a646-e31f-11e4-aace-600308960662"
      })
      |> Billing.Payments.create_audit_log()

    audit_log
  end
end
