defmodule Mimdb.Movies.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :value, :integer
    field :user_id, :id
    field :movie_id, :id

    timestamps()
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:value, :user_id, :movie_id])
    |> validate_required([:value])
    |> unique_constraint([:user_id, :movie_id])
  end
end
