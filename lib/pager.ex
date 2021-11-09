defmodule Pager do
  import Ecto.Query, warn: false
  alias Pager.Repo

  @moduledoc """
  Documentation for `Pager`.
  """

  def page(query, nil, per_page) do
    page(query, 1, per_page)
  end

  def page(query, page, per_page) when is_nil(per_page) or per_page == "" do
    page(query, page, 50)
  end

  def page(query, page, per_page) when is_binary(page) and is_binary(per_page) do
    page(query, String.to_integer(page), String.to_integer(per_page))
  end

  def page(query, page, per_page) when is_binary(page) do
    page(query, String.to_integer(page), per_page)
  end

  def page(query, page, per_page) when is_binary(per_page) do
    page(query, page, String.to_integer(per_page))
  end

  def page(query, page, per_page) do
    results = query(query, page, per_page: per_page)
    count = Repo.one(from(t in subquery(query), select: count("*")))

    %{
      has_next: length(results) > per_page,
      has_prev: page > 1,
      prev_page: page - 1,
      page: page,
      next_page: page + 1,
      first: (page - 1) * per_page + 1,
      last: Enum.min([page * per_page, count]),
      count: count,
      list: Enum.slice(results, 0, per_page)
    }
  end

  defp query(query, page, per_page: per_page) do
    query
    |> limit(^(per_page + 1))
    |> offset(^(per_page * (page - 1)))
    |> Repo.all()
  end
end
