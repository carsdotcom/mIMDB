defmodule Mimdb.Movies.Role do
  use Ecto.Schema
  import Ecto.Changeset

  schema "roles" do
    field :character, :string
    field :movie_id, :id
    field :actor_id, :id

    timestamps()
  end

  @doc false
  def changeset(role, attrs) do
    role
    |> cast(attrs, [:character, :actor_id, :movie_id])
    |> validate_required([:character])
  end
end
