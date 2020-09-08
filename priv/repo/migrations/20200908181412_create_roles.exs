defmodule Mimdb.Repo.Migrations.CreateRoles do
  use Ecto.Migration

  def change do
    create table(:roles) do
      add :character, :string
      add :movie_id, references(:movies, on_delete: :nothing)
      add :actor_id, references(:actors, on_delete: :nothing)

      timestamps()
    end

    create index(:roles, [:movie_id])
    create index(:roles, [:actor_id])
  end
end
