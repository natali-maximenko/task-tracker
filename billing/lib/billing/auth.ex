defmodule Billing.Auth do
  @moduledoc """
  Auth module
  """
  import Plug.Conn
  import Phoenix.Controller

  alias Billing.Auth.Guardian

  def authenticate_user(email, password) do
    verify(email, password) |> handle_response()
  end

  defp handle_response(%{"data" => data, "status" => "ok", "message" => _}) do
    {:ok, user, _claims} = Guardian.resource_from_token(data["token"])
    {:ok, user}
  end

  defp handle_response(%{"data" => _data, "status" => _status, "message" => msg}) do
    {:error, msg}
  end

  defp verify(email, password) do
    headers = [{"Content-Type", "application/json"}]

    url =
      Application.get_env(:billing, :auth_host) <>
        Application.get_env(:billing, :auth_endpoint)

    body = Jason.encode!(%{"email" => email, "password" => password})

    case HTTPoison.post(url, body, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts(body)
        Jason.decode!(body)

      {:ok, %HTTPoison.Response{status_code: 401, body: body}} ->
        IO.puts(body)
        Jason.decode!(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts("Not found :(")

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect(reason)
    end
  end

  def redirect_if_user_is_authenticated(conn, _opts) do
    if Guardian.Plug.authenticated?(conn) do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  defp signed_in_path(_conn), do: "/"
end
