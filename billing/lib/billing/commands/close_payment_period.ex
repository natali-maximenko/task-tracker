defmodule Billing.Commands.ClosePaymentPeriod do
  @moduledoc """
  Закрывает период каждую ночь, за прошедший день
  """
  alias Billing.{Accounts, Payments}
  alias Billing.Accounts.User

  def call do
    Accounts.list_employees()
    |> Enum.map(&close_period/1)
  end

  def close_period(%User{public_id: employee_id}) do
    period_start = Timex.now() |> Timex.shift(days: -1) |> Timex.beginning_of_day()
    period_end = Timex.now() |> Timex.shift(days: -1) |> Timex.end_of_day()

    Payments.calc_profit_by_employee(employee_id, period_start, period_end)
    |> handle_profit(employee_id)
  end

  defp handle_profit(price, employee_id) when price > 0 do
    # audit log
    today = Timex.today() |> Timex.shift(days: -1) |> to_string()

    Payments.create_audit_log(%{
      employee_id: employee_id,
      debit: price,
      description: "Payment of day: #{today}"
    })

    # change balance
    Payments.find_employee_bill(employee_id)
    |> Payments.zero_balance()

    # send email
  end

  defp handle_profit(_price, _employee_id), do: :ok
end
