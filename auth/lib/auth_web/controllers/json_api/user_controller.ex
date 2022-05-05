defmodule AuthWeb.JsonApi.UserController do
  use AuthWeb, :controller

  def random_employee_id(conn, _params) do
    case Auth.Accounts.get_random_employee_id() do
      nil ->
        conn
        |> render("error.json", message: "Employee not found")

      id ->
        conn
        |> render("employee_id.json", %{public_id: id})
    end
  end
end
