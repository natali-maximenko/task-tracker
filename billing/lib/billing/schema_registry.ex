defmodule Billing.SchemaRegistry do
  @moduledoc """
  Schema registry
  """

  def load_schema(domain, event, version \\ 1) do
    "./schemas/#{domain}/#{event}/#{version}.json"
    |> Path.expand()
    |> File.read!()
    |> Jason.decode!()
    |> ExJsonSchema.Schema.resolve()
  end

  def validate(schema, data) do
    ExJsonSchema.Validator.validate(schema, data)
  end
end
