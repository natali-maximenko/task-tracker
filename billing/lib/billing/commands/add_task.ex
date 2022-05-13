defmodule Billing.Commands.AddTask do
  @moduledoc """
  Заводит задачу в системе
  """
  alias Billing.{Payments, Tasks}
  alias Billing.Tasks.Task

  def call(attrs) do
    attrs
    |> Map.merge(%{"assign_price" => generate_assign_price(), "complete_price" => generate_complete_price()})
    |> IO.inspect()
    |> Tasks.create_task()
    |> assign_payment()
  end

  defp assign_payment({:ok, %Task{employee_id: public_id, assign_price: price}}) do
    Payments.find_employee_bill(public_id)
    |> Payments.change_balance(price)
  end

  defp generate_assign_price, do: Enum.random(-10..-20)
  defp generate_complete_price, do: Enum.random(20..40)
end
