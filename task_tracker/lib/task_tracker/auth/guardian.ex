defmodule TaskTracker.Auth.Guardian do
  use Guardian, otp_app: :task_tracker
  alias TaskTracker.Auth.User

  def subject_for_token(%User{public_id: uid, role: role}, _claims) do
    {:ok, "User:#{uid}|#{role}"}
  end

  def subject_for_token(_, _), do: {:error, :unhandled_resource_type}

  def resource_from_claims(%{"sub" => "User:" <> sub}) do
    [uid, role] = String.split(sub, "|")
    {:ok, %User{public_id: uid, role: role}}
  end

  def resource_from_claims(_), do: {:error, :unhandled_resource_type}
end
