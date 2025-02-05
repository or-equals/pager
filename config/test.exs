import Config

config :pager, ecto_repos: [Pager.Repo]

config :pager, Pager.Repo,
  database: "pager_test",
  pool: Ecto.Adapters.SQL.Sandbox,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

config :logger, :console, level: :error
