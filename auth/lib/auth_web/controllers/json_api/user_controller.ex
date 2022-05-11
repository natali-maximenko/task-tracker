defmodule AuthWeb.JsonApi.UserController do
  use AuthWeb, :controller
  alias Auth.Accounts

  def random_employee_id(conn, _params) do
    case Accounts.get_random_employee_id() do
      nil ->
        conn
        |> render("error.json", message: "Employee not found")

      id ->
        conn
        |> render("employee_id.json", %{public_id: id})
    end
  end

  def list_employee(conn, _params) do
    case Accounts.list_employee_ids() do
      nil ->
        conn
        |> render("error.json", message: "Employees not found")

      ids ->
        conn
        |> render("employees.json", %{ids: ids})
    end
  end
end
