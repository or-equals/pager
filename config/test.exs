import Config

config :pager, ecto_repos: [Pager.Repo]

config :pager, Pager.Repo,
  database: "pager_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  username: "postgres"

config :logger, :console, level: :error
