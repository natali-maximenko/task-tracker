defmodule Billing.Payments do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false

  alias Billing.Repo
  alias Billing.Payments.Bill
  alias Billing.Accounts.User

  def list_bills do
    Repo.all(Bill)
  end

  def find_employee_bill(employee_id) do
    Repo.get_by!(Bill, employee_id: employee_id)
  end

  def create_bill({:ok, %User{public_id: id}}) do
    %Bill{}
    |> Bill.changeset(%{employee_id: id})
    |> Repo.insert()
  end

  def create_bill(attrs) do
    %Bill{}
    |> Bill.changeset(attrs)
    |> Repo.insert()
  end

  def change_balance(%Bill{} = bill, price) do
    bill
    |> Bill.update_changeset(%{balance: bill.balance + price})
    |> Repo.update()
  end
end
