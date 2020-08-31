defmodule Mimdb.Movies.Genre do
  use Ecto.Schema
  import Ecto.Changeset

  schema "genres" do
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(genre, attrs) do
    genre
    |> cast(attrs, [:name])
    |> unique_constraint([:name])
    |> validate_required([:name])
  end
end
