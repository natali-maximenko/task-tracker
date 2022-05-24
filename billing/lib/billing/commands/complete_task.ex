defmodule Billing.Commands.CompleteTask do
  @moduledoc """
  Закрывает задачу в системе
  """
  alias Billing.{Payments, Tasks}
  alias Billing.Tasks.Task

  def call(%{"employee_id" => _public_id, "public_id" => task_id}) do
    task_id
    |> Tasks.find_task()
    # |> check_employee public_id == task.employee_id
    |> complete_payment()
  end

  defp complete_payment(%Task{employee_id: public_id, complete_price: price, description: desc}) do
    Payments.find_employee_bill(public_id)
    |> Payments.change_balance(price)

    Payments.create_audit_log(%{employee_id: public_id, debit: price, description: desc})
  end
end
