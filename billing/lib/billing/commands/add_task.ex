defmodule Billing.Commands.AddTask do
  @moduledoc """
  Заводит задачу в системе
  """
  alias Billing.{Payments, Tasks}
  alias Billing.Tasks.Task

  def call(attrs) do
    attrs
    |> Map.merge(%{"assign_price" => gen_assign_price(), "complete_price" => gen_complete_price()})
    |> Tasks.create_task()
    |> assign_payment()
  end

  defp assign_payment({:ok, %Task{employee_id: public_id, assign_price: price, description: desc}}) do
    Payments.find_employee_bill(public_id)
    |> Payments.change_balance(price)

    Payments.create_audit_log(%{employee_id: public_id, credit: price * -1, description: desc})
  end

  defp gen_assign_price, do: Enum.random(-10..-20)
  defp gen_complete_price, do: Enum.random(20..40)
end
