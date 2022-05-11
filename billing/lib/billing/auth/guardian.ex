defmodule Billing.Auth.Guardian do
  use Guardian, otp_app: :billing
  
  alias Billing.Accounts
  alias Billing.Accounts.User

  def subject_for_token(%User{public_id: uid, role: role}, _claims) do
    {:ok, "User:#{uid}|#{role}"}
  end

  def subject_for_token(_, _), do: {:error, :unhandled_resource_type}

  def resource_from_claims(%{"sub" => "User:" <> sub}) do
    [uid, _role] = String.split(sub, "|")
    user = Accounts.get_user_by_uuid(uid)
    {:ok, user}
  end

  def resource_from_claims(_), do: {:error, :unhandled_resource_type}
end
