defmodule MimdbWeb.MovieView do
  use MimdbWeb, :view

  alias Mimdb.Movies

  def builder() do
    MimdbWeb.SharedView.builder()
  end

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
    Movies.get_rating!(current_user.id, movie.id)
    |> get_rating_value
  end

  def get_rating_value(nil) do
    0
  end

  def get_rating_value(rating) do
    rating.value
  end

  def get_rating_average(movie) do
    (Movies.rating_average(movie) || 0.0)
    |> Float.ceil(1)
  end

  def get_rating_count(movie) do
    Movies.rating_count(movie)
  end
end
