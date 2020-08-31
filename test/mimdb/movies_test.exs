defmodule Mimdb.MoviesTest do
  use Mimdb.DataCase

  alias Mimdb.Movies

  describe "genres" do
    alias Mimdb.Movies.Genre

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def genre_fixture(attrs \\ %{}) do
      {:ok, genre} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Movies.create_genre()

      genre
    end

    test "list_genres/0 returns all genres" do
      genre = genre_fixture()
      assert Movies.list_genres() == [genre]
    end

    test "get_genre!/1 returns the genre with given id" do
      genre = genre_fixture()
      assert Movies.get_genre!(genre.id) == genre
    end

    test "create_genre/1 with valid data creates a genre" do
      assert {:ok, %Genre{} = genre} = Movies.create_genre(@valid_attrs)
      assert genre.name == "some name"
    end

    test "create_genre/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Movies.create_genre(@invalid_attrs)
    end

    test "create_genre/1 with duplicate data returns error changeset" do
      _ = genre_fixture()

      assert {:error, %Ecto.Changeset{}} = Movies.create_genre(@valid_attrs)
    end

    test "update_genre/2 with valid data updates the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{} = genre} = Movies.update_genre(genre, @update_attrs)
      assert genre.name == "some updated name"
    end

    test "update_genre/2 with invalid data returns error changeset" do
      genre = genre_fixture()
      assert {:error, %Ecto.Changeset{}} = Movies.update_genre(genre, @invalid_attrs)
      assert genre == Movies.get_genre!(genre.id)
    end

    test "delete_genre/1 deletes the genre" do
      genre = genre_fixture()
      assert {:ok, %Genre{}} = Movies.delete_genre(genre)
      assert_raise Ecto.NoResultsError, fn -> Movies.get_genre!(genre.id) end
    end

    test "change_genre/1 returns a genre changeset" do
      genre = genre_fixture()
      assert %Ecto.Changeset{} = Movies.change_genre(genre)
  describe "actors" do
    alias Mimdb.Movies.Actor

    @valid_attrs %{birthdate: ~D[2010-04-17], name: "some name"}
    @update_attrs %{birthdate: ~D[2011-05-18], name: "some updated name"}
    @invalid_attrs %{birthdate: nil, name: nil}

    def actor_fixture(attrs \\ %{}) do
      {:ok, actor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Movies.create_actor()

      actor
    end

    test "list_actors/0 returns all actors" do
      actor = actor_fixture()
      assert Movies.list_actors() == [actor]
    end

    test "get_actor!/1 returns the actor with given id" do
      actor = actor_fixture()
      assert Movies.get_actor!(actor.id) == actor
    end

    test "create_actor/1 with valid data creates a actor" do
      assert {:ok, %Actor{} = actor} = Movies.create_actor(@valid_attrs)
      assert actor.birthdate == ~D[2010-04-17]
      assert actor.name == "some name"
    end

    test "create_actor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Movies.create_actor(@invalid_attrs)
    end

    test "update_actor/2 with valid data updates the actor" do
      actor = actor_fixture()
      assert {:ok, %Actor{} = actor} = Movies.update_actor(actor, @update_attrs)
      assert actor.birthdate == ~D[2011-05-18]
      assert actor.name == "some updated name"
    end

    test "update_actor/2 with invalid data returns error changeset" do
      actor = actor_fixture()
      assert {:error, %Ecto.Changeset{}} = Movies.update_actor(actor, @invalid_attrs)
      assert actor == Movies.get_actor!(actor.id)
    end

    test "delete_actor/1 deletes the actor" do
      actor = actor_fixture()
      assert {:ok, %Actor{}} = Movies.delete_actor(actor)
      assert_raise Ecto.NoResultsError, fn -> Movies.get_actor!(actor.id) end
    end

    test "change_actor/1 returns a actor changeset" do
      actor = actor_fixture()
      assert %Ecto.Changeset{} = Movies.change_actor(actor)
    end
  end
end
