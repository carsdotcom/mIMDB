defmodule Mimdb.Repo.Migrations.CreateMoviesGenres do
  use Ecto.Migration

  def change do
    create table(:movies_genres) do
      add :movie_id, references(:movies, on_delete: :nothing)
      add :genre_id, references(:genres, on_delete: :nothing)

      timestamps()
    end

    create index(:movies_genres, [:movie_id])
    create index(:movies_genres, [:genre_id])
  end
end
