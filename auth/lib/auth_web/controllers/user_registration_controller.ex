defmodule AuthWeb.UserRegistrationController do
  use AuthWeb, :controller

  alias Auth.{Accounts, SchemaRegistry}
  alias Auth.Accounts.User
  alias Auth.Kafka.Producer
  alias AuthWeb.UserAuth

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  @event_schema SchemaRegistry.load_schema("accounts", "account_registered")
  def create(conn, %{"user" => user_params}) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &Routes.user_confirmation_url(conn, :edit, &1)
          )

        data = %{"email" => user.email, "name" => user.name, "public_id" => user.public_id, "role" => user.role}
        event = %{
          "event_id" => Ecto.UUID.generate,
          "event_version" => 1,
          "event_time" => DateTime.now!("Etc/UTC") |> to_string(),
          "event_name" => "account_registered",
          "producer" => "auth",
          "data" => data}
        :ok = SchemaRegistry.validate(@event_schema, event)
        Producer.send_message("accounts-stream", event)

        conn
        |> put_flash(:info, "User created successfully.")
        |> UserAuth.log_in_user(user)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
