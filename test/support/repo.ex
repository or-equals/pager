defmodule Pager.Repo do
  use Ecto.Repo, otp_app: :pager, adapter: Ecto.Adapters.Postgres
end
