defmodule Mimdb.Actors.Actor do
  use Ecto.Schema
  import Ecto.Changeset

  schema "actors" do
    field :birthdate, :date
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(actor, attrs) do
    actor
    |> cast(attrs, [:name, :birthdate])
    |> validate_required([:name, :birthdate])
  end
end
