defmodule Pager do
  import Ecto.Query, warn: false

  @moduledoc """
  Documentation for `Pager`.
  """

  def page(query, repo, nil, per_page) do
    page(query, repo, 1, per_page)
  end

  def page(query, repo, page, per_page) when is_nil(per_page) or per_page == "" do
    page(query, repo, page, 50)
  end

  def page(query, repo, page, per_page) when is_binary(page) and is_binary(per_page) do
    page(query, repo, String.to_integer(page), String.to_integer(per_page))
  end

  def page(query, repo, page, per_page) when is_binary(page) do
    page(query, repo, String.to_integer(page), per_page)
  end

  def page(query, repo, page, per_page) when is_binary(per_page) do
    page(query, repo, page, String.to_integer(per_page))
  end

  def page(query, repo, page, per_page) do
    results = query(query, repo, page, per_page: per_page)
    count = repo.one(from(t in subquery(query), select: count("*")))
    first = (page - 1) * per_page + 1

    if (first > count && count > 0) do
      page(query, repo, 1, per_page)
    else
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
  end

  defp query(query, repo, page, per_page: per_page) do
    query
    |> limit(^(per_page + 1))
    |> offset(^(per_page * (page - 1)))
    |> repo.all()
  end
end
