defmodule MimdbWeb.GenreController do
  use MimdbWeb, :controller

  alias Mimdb.Movies
  alias Mimdb.Movies.Genre

  def index(conn, _params) do
    genres = Movies.list_genres()
    render(conn, "index.html", genres: genres)
  end

  def new(conn, _params) do
    changeset = Movies.change_genre(%Genre{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"genre" => genre_params}) do
    case Movies.create_genre(genre_params) do
      {:ok, _genre} ->
        conn
        |> put_flash(:info, "Genre created successfully.")
        |> redirect(to: Routes.genre_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => id}) do
    genre = Movies.get_genre!(id)
    changeset = Movies.change_genre(genre)
    render(conn, "edit.html", genre: genre, changeset: changeset)
  end

  def update(conn, %{"id" => id, "genre" => genre_params}) do
    genre = Movies.get_genre!(id)

    case Movies.update_genre(genre, genre_params) do
      {:ok, _genre} ->
        conn
        |> put_flash(:info, "Genre updated successfully.")
        |> redirect(to: Routes.genre_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", genre: genre, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    genre = Movies.get_genre!(id)
    {:ok, _genre} = Movies.delete_genre(genre)

    conn
    |> put_flash(:info, "Genre deleted successfully.")
    |> redirect(to: Routes.genre_path(conn, :index))
  end
end
