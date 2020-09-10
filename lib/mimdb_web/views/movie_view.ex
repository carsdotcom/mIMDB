defmodule MimdbWeb.MovieView do
  use MimdbWeb, :view

  def is_genre_selected(genre, changeset) do
    changeset.data.genres
    |> Enum.map(& &1.id)
    |> Enum.member?(genre.id)
  end

  def sort_movies(movies) do
    Enum.sort_by(movies, &(&1.title))
  end

  def genre_select_options(genres) do
    genres
    |> Enum.map(&{&1.name, &1.id})
    |> List.insert_at(0, {"All", 0})
  end
end
