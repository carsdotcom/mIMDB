defmodule Mimdb.Repo.Migrations.CreateRatings do
  use Ecto.Migration

  def change do
    create table(:ratings) do
      add :value, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :movie_id, references(:movies, on_delete: :nothing)

      timestamps()
    end

    create index(:ratings, [:user_id])
    create index(:ratings, [:movie_id])
  end
end
