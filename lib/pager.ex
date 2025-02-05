defmodule Pager do
  import Ecto.Query, warn: false

  @moduledoc """
  Provides pagination functionality for Ecto queries.

  This module offers a simple way to paginate Ecto query results with automatic
  handling of page boundaries, flexible parameter types, and consistent return structure.
  """

  @typedoc """
  Pagination result containing pagination metadata and list of items.

  Fields:
  * `has_next` - Indicates if there are more pages after the current one
  * `has_prev` - Indicates if there are pages before the current one
  * `prev_page` - Previous page number
  * `page` - Current page number
  * `next_page` - Next page number
  * `first` - Index of first item on current page
  * `last` - Index of last item on current page
  * `count` - Total number of items across all pages
  * `list` - List of results/items on the current page
  """
  @type page_result :: %{
    has_next: boolean(),
    has_prev: boolean(),
    prev_page: integer(),
    page: integer(),
    next_page: integer(),
    first: integer(),
    last: integer(),
    count: integer(),
    list: [any()]
  }

  @doc """
  Paginates an Ecto query with flexible parameter handling.

  # Parameters

  * `query` - An Ecto query to paginate
  * `repo` - The Ecto repo to execute the query
  * `page` - Page number (integer or string, defaults to 1)
  * `per_page` - Items per page (integer or string, defaults to 50)

  # Examples

      iex> alias Pager.{User, Repo}
      iex> query = from(u in User)
      iex> result = Pager.page(query, Repo, 1, 20)
      iex> Map.drop(result, [:list])
      %{count: 0, first: 1, has_next: false, has_prev: false, last: 0, next_page: 2, page: 1, prev_page: 0}

      # String parameters (e.g. from Phoenix params)
      iex> alias Pager.{User, Repo}
      iex> query = from(u in User)
      iex> result = Pager.page(query, Repo, "2", "10")
      iex> Map.drop(result, [:list])
      %{count: 0, first: 11, has_next: false, has_prev: true, last: 0, next_page: 3, page: 2, prev_page: 1}

      # With defaults
      iex> alias Pager.{User, Repo}
      iex> query = from(u in User)
      iex> result = Pager.page(query, Repo, nil, 50)
      iex> Map.drop(result, [:list])
      %{count: 0, first: 1, has_next: false, has_prev: false, last: 0, next_page: 2, page: 1, prev_page: 0}
  """
  @spec page(Ecto.Query.t(), Ecto.Repo.t(), integer() | binary() | nil, integer() | binary() | nil) :: page_result()
  def page(query, repo, nil, per_page), do: page(query, repo, 1, per_page)
  def page(query, repo, page, per_page) when is_nil(per_page) or per_page == "", do: page(query, repo, page, 50)
  def page(query, repo, page, per_page) when is_binary(page) and is_binary(per_page), do: page(query, repo, String.to_integer(page), String.to_integer(per_page))
  def page(query, repo, page, per_page) when is_binary(page), do: page(query, repo, String.to_integer(page), per_page)
  def page(query, repo, page, per_page) when is_binary(per_page), do: page(query, repo, page, String.to_integer(per_page))
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
