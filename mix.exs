defmodule Pager.MixProject do
  use Mix.Project

  def project do
    [
      app: :page,
      name: "Pager",
      description: "Completely Decoupled Pagination library for Ecto Queries",
      source_url: "http://github.com/or-equals/pager",
      elixir: ">= 1.11.0",
      version: "0.1.0",
      package: package(),
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
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
    ]
  end

  defp package do
    [
      maintainers: ["Joshua Plicque"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/or-equals/pager"}
    ]
  end
end