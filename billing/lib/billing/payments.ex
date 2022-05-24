defmodule Billing.Payments do
  @moduledoc """
  The Payments context.
  """
  import Ecto.Query, warn: false

  alias Billing.Repo
  alias Billing.Payments.{AuditLog, Bill}
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

  def zero_balance(%Bill{} = bill) do
    bill
    |> Bill.update_changeset(%{balance: 0})
    |> Repo.update()
  end

  def calc_profit do
    start_time = Timex.now() |> Timex.beginning_of_day()
    end_time = Timex.now() |> Timex.end_of_day()

    q =
      from l in AuditLog,
        where: l.inserted_at > ^start_time and l.inserted_at <= ^end_time,
        select: [sum(l.credit), sum(l.debit)]

    [credit, debit] = Repo.one(q)
    credit - debit
  end

  def calc_profit_by_employee(employee_id, start_time, end_time) do
    query =
      from l in AuditLog,
        select: [sum(l.credit), sum(l.debit)],
        where:
          l.employee_id == ^employee_id and l.inserted_at > ^start_time and
            l.inserted_at <= ^end_time

    [credit, debit] = Repo.one(query)
    credit - debit
  end

  @doc """
  Returns the list of audit_logs.

  ## Examples

      iex> list_audit_logs()
      [%AuditLog{}, ...]

  """
  def list_audit_logs do
    Repo.all(AuditLog)
  end

  @doc """
  Gets a single audit_log.

  Raises `Ecto.NoResultsError` if the Audit log does not exist.

  ## Examples

      iex> get_audit_log!(123)
      %AuditLog{}

      iex> get_audit_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_audit_log!(id), do: Repo.get!(AuditLog, id)

  @doc """
  Creates a audit_log.

  ## Examples

      iex> create_audit_log(%{field: value})
      {:ok, %AuditLog{}}

      iex> create_audit_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_audit_log(attrs \\ %{}) do
    %AuditLog{}
    |> AuditLog.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a audit_log.

  ## Examples

      iex> update_audit_log(audit_log, %{field: new_value})
      {:ok, %AuditLog{}}

      iex> update_audit_log(audit_log, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_audit_log(%AuditLog{} = audit_log, attrs) do
    audit_log
    |> AuditLog.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a audit_log.

  ## Examples

      iex> delete_audit_log(audit_log)
      {:ok, %AuditLog{}}

      iex> delete_audit_log(audit_log)
      {:error, %Ecto.Changeset{}}

  """
  def delete_audit_log(%AuditLog{} = audit_log) do
    Repo.delete(audit_log)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking audit_log changes.

  ## Examples

      iex> change_audit_log(audit_log)
      %Ecto.Changeset{data: %AuditLog{}}

  """
  def change_audit_log(%AuditLog{} = audit_log, attrs \\ %{}) do
    AuditLog.changeset(audit_log, attrs)
  end
end
