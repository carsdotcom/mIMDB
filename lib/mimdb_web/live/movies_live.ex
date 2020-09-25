defmodule MimdbWeb.MoviesLive do
  use MimdbWeb, :live_view
  alias Mimdb.Movies
  alias Mimdb.Movies.Movie
  def mount(_params, session, socket) do
    IO.inspect(session, label: "session")
    user = session["current_user"]
    movies = Movies.list_movies(%{}, user.id)
    {:ok, assign(socket, movies: movies, genres: Movies.list_genres() )}
  end
end
~
~
