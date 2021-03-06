defmodule MimdbWeb.GenreControllerTest do
  use MimdbWeb.ConnCase

  alias Mimdb.Movies

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  def fixture(:genre) do
    {:ok, genre} = Movies.create_genre(@create_attrs)
    genre
  end

  describe "index" do
    test "lists all genres", %{conn: conn} do
      conn = get(conn, Routes.genre_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Genres"
    end
  end

  describe "new genre" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.genre_path(conn, :new))
      assert html_response(conn, 200) =~ "New Genre"
    end
  end

  describe "create genre" do
    test "redirects to index when data is valid", %{conn: conn} do
      conn = post(conn, Routes.genre_path(conn, :create), genre: @create_attrs)

      assert redirected_to(conn) == Routes.genre_path(conn, :index)

      conn = get(conn, Routes.genre_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Genres"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.genre_path(conn, :create), genre: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Genre"
    end
  end

  describe "edit genre" do
    setup [:create_genre]

    test "renders form for editing chosen genre", %{conn: conn, genre: genre} do
      conn = get(conn, Routes.genre_path(conn, :edit, genre))
      assert html_response(conn, 200) =~ "Edit Genre"
    end
  end

  describe "update genre" do
    setup [:create_genre]

    test "redirects when data is valid", %{conn: conn, genre: genre} do
      conn = put(conn, Routes.genre_path(conn, :update, genre), genre: @update_attrs)
      assert redirected_to(conn) == Routes.genre_path(conn, :index)

      conn = get(conn, Routes.genre_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Genres"
    end

    test "renders errors when data is invalid", %{conn: conn, genre: genre} do
      conn = put(conn, Routes.genre_path(conn, :update, genre), genre: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Genre"
    end
  end

  describe "delete genre" do
    setup [:create_genre]

    test "deletes chosen genre", %{conn: conn, genre: genre} do
      conn = delete(conn, Routes.genre_path(conn, :delete, genre))
      assert redirected_to(conn) == Routes.genre_path(conn, :index)

      conn = get(conn, Routes.genre_path(conn, :index))
      refute html_response(conn, 200) =~ genre.name
    end
  end

  defp create_genre(_) do
    genre = fixture(:genre)
    %{genre: genre}
  end
end
