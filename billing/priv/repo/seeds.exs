# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Billing.Repo.insert!(%Billing.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
users = [
  %{email: "admin@tasktracker.ru", name: "admin", role: "admin", public_id: "bcdcf25e-a403-420d-917d-aef7ccfc54b3"},
  %{email: "manager@tasktracker.ru", name: "manager", role: "manager", public_id: "6eddd895-120f-450c-9e78-9331f7889ce1"},
  %{email: "popug@tasktracker.ru", name: "Popug", role: "employee", public_id: "88ec83a5-8b2e-43ef-8b6d-63b200315c9e"},
  %{email: "popug2@tasktracker.ru", name: "Popug 2", role: "employee", public_id: "5fbef08c-94d7-4e23-a84a-3a8c75de449f"},
  %{email: "popug3@tasktracker.ru", name: "Popug 3", role: "employee", public_id: "6cc9449e-c9c8-4a3c-9093-cbb1c2b4cfb5"}
]

Enum.map(users, &Billing.Accounts.create_user/1)
