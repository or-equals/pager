defmodule PagerTest do
  use Pager.TestCase
  doctest Pager
  alias Pager.Repo

  import Ecto.Query, warn: false

  def user_fixture() do
    Repo.insert!(%User{})
  end

  describe "page/4" do
    test "returns results with pagination support" do
      _user_one = user_fixture()
      user_two = user_fixture()

      query = order_by(User, desc: :id)
      page = 1
      per_page = 1

      assert Pager.page(query, Repo, page, per_page) == %{
        has_next: true,
        has_prev: false,
        prev_page: 0,
        page: 1,
        next_page: 2,
        first: 1,
        last: 1,
        count: 2,
        list: [user_two]
      }
    end

    test "supports page and per_page as string parameters" do
      _user_one = user_fixture()
      user_two = user_fixture()
      _user_three = user_fixture()

      query = order_by(User, desc: :id)
      page = "2"
      per_page = "1"

      assert Pager.page(query, Repo, page, per_page) == %{
        has_next: true,
        has_prev: true,
        prev_page: 1,
        page: 2,
        next_page: 3,
        first: 2,
        last: 2,
        count: 3,
        list: [user_two]
      }
    end

    test "supports page as string parameter" do
      _user_one = user_fixture()
      user_two = user_fixture()
      _user_three = user_fixture()

      query = order_by(User, desc: :id)
      page = "2"
      per_page = 1

      assert Pager.page(query, Repo, page, per_page) == %{
        has_next: true,
        has_prev: true,
        prev_page: 1,
        page: 2,
        next_page: 3,
        first: 2,
        last: 2,
        count: 3,
        list: [user_two]
      }
    end

    test "supports per_page as string parameter" do
      _user_one = user_fixture()
      user_two = user_fixture()
      _user_three = user_fixture()

      query = order_by(User, desc: :id)
      page = 2
      per_page = "1"

      assert Pager.page(query, Repo, page, per_page) == %{
        has_next: true,
        has_prev: true,
        prev_page: 1,
        page: 2,
        next_page: 3,
        first: 2,
        last: 2,
        count: 3,
        list: [user_two]
      }
    end

    test "default to 50 per page when per_page is nil" do
      user_one = user_fixture()
      user_two = user_fixture()
      user_three = user_fixture()

      query = order_by(User, desc: :id)
      page = 1
      per_page = nil

      assert Pager.page(query, Repo, page, per_page) == %{
        has_next: false,
        has_prev: false,
        prev_page: 0,
        page: 1,
        next_page: 2,
        first: 1,
        last: 3,
        count: 3,
        list: [user_three, user_two, user_one]
      }
    end

    test "default to 50 per page when per_page is an empty string" do
      user_one = user_fixture()
      user_two = user_fixture()
      user_three = user_fixture()

      query = order_by(User, desc: :id)
      page = 1
      per_page = ""

      assert Pager.page(query, Repo, page, per_page) == %{
        has_next: false,
        has_prev: false,
        prev_page: 0,
        page: 1,
        next_page: 2,
        first: 1,
        last: 3,
        count: 3,
        list: [user_three, user_two, user_one]
      }
    end

    test "set page to 1 when nil" do
      user_one = user_fixture()
      user_two = user_fixture()
      user_three = user_fixture()

      query = order_by(User, desc: :id)
      page = nil
      per_page = 8

      assert Pager.page(query, Repo, page, per_page) == %{
        has_next: false,
        has_prev: false,
        prev_page: 0,
        page: 1,
        next_page: 2,
        first: 1,
        last: 3,
        count: 3,
        list: [user_three, user_two, user_one]
      }
    end

    test "set page to 1 when first > count" do
      user_one = user_fixture()
      user_two = user_fixture()
      user_three = user_fixture()

      query = order_by(User, desc: :id)
      page = 50
      per_page = 8

      assert Pager.page(query, Repo, page, per_page) == %{
        has_next: false,
        has_prev: false,
        prev_page: 0,
        page: 1,
        next_page: 2,
        first: 1,
        last: 3,
        count: 3,
        list: [user_three, user_two, user_one]
      }
    end

    test "no results" do
      query = order_by(User, desc: :id)
      page = 1
      per_page = 30

      assert Pager.page(query, Repo, page, per_page) == %{
        has_next: false,
        has_prev: false,
        prev_page: 0,
        page: 1,
        next_page: 2,
        first: 1,
        last: 0,
        count: 0,
        list: []
      }
    end
  end
end
