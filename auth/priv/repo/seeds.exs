# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Auth.Repo.insert!(%Auth.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
users = [
  %{email: "admin@tasktracker.ru", password: "adminTrue", role: "admin"},
  %{email: "manager@tasktracker.ru", password: "managerTrue", role: "manager"},
  %{email: "popug@tasktracker.ru", password: "123456", name: "Popug"},
  %{email: "popug2@tasktracker.ru", password: "123456", name: "Popug 2"},
  %{email: "popug3@tasktracker.ru", password: "123456", name: "Popug 3"}
]

Enum.map(users, &Auth.Accounts.add_user/1)
