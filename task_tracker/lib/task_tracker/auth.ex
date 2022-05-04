defmodule TaskTracker.Auth do
  @moduledoc """
  Mock auth service
  """

  def get_employee_id, do: Ecto.UUID.generate()
end
