defmodule MimdbWeb.MovieController do
  use MimdbWeb, :controller

  alias Mimdb.Movies
  alias Mimdb.Movies.Movie

  def index(conn, params) do
    user = conn.assigns.current_user

    if user do
      movies = Movies.list_movies(params, user.id)
      render(conn, "index.html", movies: movies, genres: Movies.list_genres())
    else
      redirect(conn, to: Routes.user_session_path(conn, :new))
    end
  end

  def new(conn, _params) do
    changeset = Movies.change_movie(%Movie{})
    genres = Movies.list_genres()
    render(conn, "new.html", changeset: changeset, genres: genres)
  end

  def create(conn, %{"movie" => movie_params}) do
    case Movies.create_movie(movie_params) do
      {:ok, _movie} ->
        conn
        |> put_flash(:info, "Movie created successfully.")
        |> redirect(to: Routes.movie_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset, genres: Movies.list_genres())
    end
  end

  def show(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    render(conn, "show.html", movie: movie)
  end

  def edit(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    changeset = Movies.change_movie(movie)
    genres = Movies.list_genres()
    roles = Movies.list_roles_for_movie_with_id(id)
    render(conn, "edit.html", movie: movie, changeset: changeset, genres: genres, roles: roles)
  end

  def update(conn, %{"id" => id, "movie" => movie_params}) do
    movie = Movies.get_movie!(id)

    case Movies.update_movie(movie, movie_params) do
      {:ok, _movie} ->
        conn
        |> put_flash(:info, "Movie updated successfully.")
        |> redirect(to: Routes.movie_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html",
          movie: movie,
          changeset: changeset,
          genres: Movies.list_genres(),
          roles: Movies.list_roles()
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    movie = Movies.get_movie!(id)
    {:ok, _movie} = Movies.delete_movie(movie)

    conn
    |> put_flash(:info, "Movie deleted successfully.")
    |> redirect(to: Routes.movie_path(conn, :index))
  end

  def rate(conn, params) do
    IO.inspect(params, label: "Movies#rate params")
    Movies.rate_movie(params, conn.assigns.current_user)

    conn
    |> redirect(to: Routes.movie_path(conn, :index))
  end
end
