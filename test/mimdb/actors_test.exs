defmodule Mimdb.ActorsTest do
  use Mimdb.DataCase

  alias Mimdb.Actors

  describe "actors" do
    alias Mimdb.Actors.Actor

    @valid_attrs %{birthdate: ~D[2010-04-17], name: "some name"}
    @update_attrs %{birthdate: ~D[2011-05-18], name: "some updated name"}
    @invalid_attrs %{birthdate: nil, name: nil}

    def actor_fixture(attrs \\ %{}) do
      {:ok, actor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Actors.create_actor()

      actor
    end

    test "list_actors/0 returns all actors" do
      actor = actor_fixture()
      assert Actors.list_actors() == [actor]
    end

    test "get_actor!/1 returns the actor with given id" do
      actor = actor_fixture()
      assert Actors.get_actor!(actor.id) == actor
    end

    test "create_actor/1 with valid data creates a actor" do
      assert {:ok, %Actor{} = actor} = Actors.create_actor(@valid_attrs)
      assert actor.birthdate == ~D[2010-04-17]
      assert actor.name == "some name"
    end

    test "create_actor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Actors.create_actor(@invalid_attrs)
    end

    test "update_actor/2 with valid data updates the actor" do
      actor = actor_fixture()
      assert {:ok, %Actor{} = actor} = Actors.update_actor(actor, @update_attrs)
      assert actor.birthdate == ~D[2011-05-18]
      assert actor.name == "some updated name"
    end

    test "update_actor/2 with invalid data returns error changeset" do
      actor = actor_fixture()
      assert {:error, %Ecto.Changeset{}} = Actors.update_actor(actor, @invalid_attrs)
      assert actor == Actors.get_actor!(actor.id)
    end

    test "delete_actor/1 deletes the actor" do
      actor = actor_fixture()
      assert {:ok, %Actor{}} = Actors.delete_actor(actor)
      assert_raise Ecto.NoResultsError, fn -> Actors.get_actor!(actor.id) end
    end

    test "change_actor/1 returns a actor changeset" do
      actor = actor_fixture()
      assert %Ecto.Changeset{} = Actors.change_actor(actor)
    end
  end
end
