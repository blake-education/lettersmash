ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Skateboard.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Skateboard.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Skateboard.Repo)

