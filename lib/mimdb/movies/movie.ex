defmodule Mimdb.Movies.Movie do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mimdb.Movies.Genre

  schema "movies" do
    field :release, :date
    field :title, :string
    many_to_many :genres, Genre, join_through: Mimdb.Movies.MoviesGenres

    timestamps()
  end

  @doc false
  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:title, :release])
    |> cast_assoc(:genres)
    |> validate_required([:title, :release])
  end
end
