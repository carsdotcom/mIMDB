defmodule Mimdb.Repo.Migrations.CreateActors do
  use Ecto.Migration

  def change do
    create table(:actors) do
      add :name, :string
      add :birthdate, :date

      timestamps()
    end
  end
end
