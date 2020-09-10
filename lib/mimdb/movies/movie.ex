defmodule Mimdb.Movies.Movie do
  use Ecto.Schema
  import Ecto.Changeset
  alias Mimdb.Movies.Genre
  alias Mimdb.Repo

  schema "movies" do
    field :release, :date
    field :title, :string

    many_to_many :genres, Genre,
      join_through: Mimdb.Movies.MoviesGenres,
      on_replace: :delete,
      on_delete: :delete_all

    timestamps()
  end

  @doc false
  def changeset(movie, attrs, genres \\ []) do
    movie
    |> Repo.preload(:genres)
    |> cast(attrs, [:title, :release])
    |> put_assoc(:genres, genres)
    |> validate_required([:title, :release])
  end
end
