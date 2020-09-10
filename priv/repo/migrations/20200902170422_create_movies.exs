defmodule Mimdb.Repo.Migrations.CreateMovies do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :title, :string
      add :release, :date

      timestamps()
    end
  end
end
