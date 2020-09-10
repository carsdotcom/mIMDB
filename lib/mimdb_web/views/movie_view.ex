defmodule MimdbWeb.MovieView do
  use MimdbWeb, :view

  def is_genre_selected(genre, changeset) do
    changeset.data.genres
    |> Enum.map(& &1.id)
    |> Enum.member?(genre.id)
  end

  def sort_movies(movies) do
    Enum.sort_by(movies, & &1.title)
  end

  def genre_select_options(genres) do
    genres
    |> Enum.map(&{&1.name, &1.id})
    |> List.insert_at(0, {"All", 0})
  end

  def rated_value(current_user, movie) do
    Mimdb.Movies.get_rating!(current_user.id, movie.id)
    |> get_rating_value
  end

  def get_rating_value(nil) do
    0
  end

  def get_rating_value(rating) do
    rating.value
  end
end
