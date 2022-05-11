defmodule BillingWeb.SessionController do
  use BillingWeb, :controller

  alias Billing.Auth
  alias Billing.Auth.Guardian

  def new(conn, _) do
    maybe_user = Guardian.Plug.current_resource(conn)

    if maybe_user do
      redirect(conn, to: "/")
    else
      render(conn, "new.html", action: Routes.session_path(conn, :login), error_message: nil)
    end
  end

  def login(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    Auth.authenticate_user(email, password)
    |> login_reply(conn)
  end

  def logout(conn, _) do
    conn
    |> Guardian.Plug.sign_out()
    |> redirect(to: "/login")
  end

  defp login_reply({:ok, user}, conn) do
    conn
    |> put_flash(:info, "Welcome back!")
    |> Guardian.Plug.sign_in(user)
    |> redirect(to: "/")
  end

  defp login_reply({:error, reason}, conn) do
    conn
    |> put_flash(:error, to_string(reason))
    |> new(%{})
  end
end
