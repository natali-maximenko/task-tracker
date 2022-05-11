defmodule TaskTracker.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TaskTracker.Accounts` context.
  """

  @doc """
  Generate a user.
  """
  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        public_id: "7488a646-e31f-11e4-aace-600308960662",
        role: "some role"
      })
      |> TaskTracker.Accounts.create_user()

    user
  end
end
