defmodule Mimdb.Movies.MoviesGenres do
  use Ecto.Schema
  import Ecto.Changeset

  schema "movies_genres" do
    field :movie_id, :id
    field :genre_id, :id

    timestamps()
  end

  @doc false
  def changeset(movies_genres, _attrs) do
    movies_genres
    |> validate_required([:movie_id, :genre_id])
  end
end
