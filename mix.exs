defmodule Pager.MixProject do
  use Mix.Project

  def project do
    [
      app: :pager,
      name: "Pager",
      description: "Completely Decoupled Pagination library for Ecto Queries",
      source_url: "http://github.com/or-equals/pager",
      elixir: ">= 1.11.0",
      elixirc_paths: elixirc_paths(Mix.env()),
      version: "0.2.0",
      package: package(),
      aliases: aliases(),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto, "~> 3.3"},
      {:ecto_sql, "~> 3.3", only: :test},
      {:postgrex, "~> 0.15.0", only: :test},
      {:ex_doc, ">= 0.0.0", only: :dev}
    ]
  end

  defp package do
    [
      maintainers: ["Joshua Plicque"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/or-equals/pager"},
      files: [
        "lib/pager.ex",
        "mix.exs",
        "README.md"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp aliases do
    [
      "db.reset": [
        "ecto.drop",
        "ecto.create",
        "ecto.migrate"
      ]
    ]
  end
end
