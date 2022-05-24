defmodule Billing.PaymentsTest do
  use Billing.DataCase

  alias Billing.Payments

  describe "audit_logs" do
    alias Billing.Payments.AuditLog

    import Billing.PaymentsFixtures

    @invalid_attrs %{credit: nil, debit: nil, description: nil, employee_id: nil}

    test "list_audit_logs/0 returns all audit_logs" do
      audit_log = audit_log_fixture()
      assert Payments.list_audit_logs() == [audit_log]
    end

    test "get_audit_log!/1 returns the audit_log with given id" do
      audit_log = audit_log_fixture()
      assert Payments.get_audit_log!(audit_log.id) == audit_log
    end

    test "create_audit_log/1 with valid data creates a audit_log" do
      valid_attrs = %{
        credit: 42,
        debit: 42,
        description: "some description",
        employee_id: "7488a646-e31f-11e4-aace-600308960662"
      }

      assert {:ok, %AuditLog{} = audit_log} = Payments.create_audit_log(valid_attrs)
      assert audit_log.credit == 42
      assert audit_log.debit == 42
      assert audit_log.description == "some description"
      assert audit_log.employee_id == "7488a646-e31f-11e4-aace-600308960662"
    end

    test "create_audit_log/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payments.create_audit_log(@invalid_attrs)
    end

    test "update_audit_log/2 with valid data updates the audit_log" do
      audit_log = audit_log_fixture()

      update_attrs = %{
        credit: 43,
        debit: 43,
        description: "some updated description",
        employee_id: "7488a646-e31f-11e4-aace-600308960668"
      }

      assert {:ok, %AuditLog{} = audit_log} = Payments.update_audit_log(audit_log, update_attrs)
      assert audit_log.credit == 43
      assert audit_log.debit == 43
      assert audit_log.description == "some updated description"
      assert audit_log.employee_id == "7488a646-e31f-11e4-aace-600308960668"
    end

    test "update_audit_log/2 with invalid data returns error changeset" do
      audit_log = audit_log_fixture()
      assert {:error, %Ecto.Changeset{}} = Payments.update_audit_log(audit_log, @invalid_attrs)
      assert audit_log == Payments.get_audit_log!(audit_log.id)
    end

    test "delete_audit_log/1 deletes the audit_log" do
      audit_log = audit_log_fixture()
      assert {:ok, %AuditLog{}} = Payments.delete_audit_log(audit_log)
      assert_raise Ecto.NoResultsError, fn -> Payments.get_audit_log!(audit_log.id) end
    end

    test "change_audit_log/1 returns a audit_log changeset" do
      audit_log = audit_log_fixture()
      assert %Ecto.Changeset{} = Payments.change_audit_log(audit_log)
    end
  end
end
