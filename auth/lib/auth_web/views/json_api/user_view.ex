defmodule AuthWeb.JsonApi.UserView do
  use AuthWeb, :view

  def render("employee_id.json", %{public_id: public_id}) do
    %{
      status: :ok,
      data: %{
        public_id: public_id
      }
    }
  end

  def render("employees.json", %{ids: ids}) do
    %{
      status: :ok,
      data: %{
        ids: ids
      }
    }
  end

  def render("error.json", %{message: message}) do
    %{
      status: :not_found,
      data: %{},
      message: message
    }
  end
end
