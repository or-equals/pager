defmodule Pager.TestCase do
  use ExUnit.CaseTemplate

  using opts do
    quote do
      use ExUnit.Case, unquote(opts)
      import Ecto.Query
    end
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Pager.Repo)
    Ecto.Adapters.SQL.Sandbox.mode(Pager.Repo, {:shared, self()})
  end
end

Pager.Repo.start_link()
Ecto.Adapters.SQL.Sandbox.mode(Pager.Repo, :manual)

ExUnit.start()
