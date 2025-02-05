# Pager

Zero-dependency pagination for Ecto queries with automatic page boundary handling and flexible parameter types.

## Features

- Clean API for paginating Ecto queries
- Handles string and integer page parameters seamlessly
- Automatic first page redirect when requested page is out of bounds
- Efficient count queries using subqueries
- Zero dependencies beyond Ecto
- Comprehensive pagination metadata

## Installation

Add `pager` to your dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pager, "~> 1.0.0"}
  ]
end
```

## Usage

```elixir
import Ecto.Query
alias YourApp.Repo
alias YourApp.Post

# Basic query pagination
query = from(p in Post)
result = Pager.page(query, Repo, 1, 20)

# Handle Phoenix params directly
def index(conn, %{"page" => page, "per_page" => per_page}) do
  query = from(p in Post, order_by: [desc: :inserted_at])
  pages = Pager.page(query, Repo, page, per_page)
  render(conn, "index.html", posts: pages.list)
end
```

### Return Structure

```elixir
%{
  has_next: true,          # More pages available
  has_prev: false,         # Previous pages available
  prev_page: 0,           # Previous page number
  page: 1,                # Current page
  next_page: 2,           # Next page number
  first: 1,               # First item index
  last: 20,               # Last item index
  count: 50,             # Total items
  list: [%Post{}, ...]   # Page items
}
```

## Documentation

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/page](https://hexdocs.pm/page).

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-feature`)
3. Commit your changes (`git commit -am 'Add feature'`)
4. Push to the branch (`git push origin my-feature`)
5. Create a Pull Request

### Development Setup

1. Create repo for tests:
```bash
MIX_ENV=test mix ecto.create
MIX_ENV=test mix ecto.migrate
mix test
```
