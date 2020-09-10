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
    end
  end

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

  describe "movies" do
    alias Mimdb.Movies.Movie

    @valid_attrs %{"release" => ~D[2010-04-17], "title" => "some title"}
    @update_attrs %{release: ~D[2011-05-18], title: "some updated title"}
    @invalid_attrs %{release: nil, title: nil}

    def movie_fixture(attrs \\ %{}) do
      {:ok, movie} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Movies.create_movie()

      movie
    end

    def create_movie_genre(actor, movie, character) do
      {:ok, role} =
        Movies.create_role(%{
          "character" => character,
          "actor_id" => actor.id,
          "movie_id" => movie.id
        })

      role
    end

    test "list_movies/1 returns all movies" do
      movie = movie_fixture()
      movie = Movies.get_only_movie(movie.id)
      assert Movies.list_movies(%{}) == [movie]
    end

    test "list_movies/1 with All query returns all movies" do
      movie = movie_fixture()
      movie = Movies.get_only_movie(movie.id)
      assert Movies.list_movies(%{"query" => "0"}) == [movie]
    end

    test "list_movies/1 with a genre_id as param returns filtered movies list by genre" do
      action = genre_fixture(%{name: "Action"})
      comedy = genre_fixture(%{name: "Comedy"})
      action_movie = movie_fixture(%{"genres" => ["#{action.id}"]})
      _comedy_movie = movie_fixture(%{"genres" => ["#{comedy.id}"]})
      created_movie = Movies.get_only_movie(action_movie.id)
      assert Movies.list_movies(%{"query" => "#{action.id}"}) == [created_movie]
    end

    test "get_movie!/1 returns the movie with given id" do
      movie = movie_fixture()
      assert Movies.get_movie!(movie.id) == movie
    end

    test "create_movie/1 with valid data creates a movie" do
      assert {:ok, %Movie{} = movie} = Movies.create_movie(@valid_attrs)
      assert movie.release == ~D[2010-04-17]
      assert movie.title == "some title"
    end

    test "create_movie/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Movies.create_movie(@invalid_attrs)
    end

    test "update_movie/2 with valid data updates the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{} = movie} = Movies.update_movie(movie, @update_attrs)
      assert movie.release == ~D[2011-05-18]
      assert movie.title == "some updated title"
    end

    test "update_movie/2 with invalid data returns error changeset" do
      movie = movie_fixture()
      assert {:error, %Ecto.Changeset{}} = Movies.update_movie(movie, @invalid_attrs)
      assert movie == Movies.get_movie!(movie.id)
    end

    test "delete_movie/1 deletes the movie" do
      movie = movie_fixture()
      assert {:ok, %Movie{}} = Movies.delete_movie(movie)
      assert_raise Ecto.NoResultsError, fn -> Movies.get_movie!(movie.id) end
    end

    test "change_movie/1 returns a movie changeset" do
      movie = movie_fixture()
      assert %Ecto.Changeset{} = Movies.change_movie(movie)
    end
  end

  describe "roles" do
    alias Mimdb.Movies.Role

    @valid_attrs %{character: "some character"}
    @update_attrs %{character: "some updated character"}
    @invalid_attrs %{character: nil}

    def role_fixture do
      actor = actor_fixture()
      movie = movie_fixture()

      {:ok, role} =
        %{actor_id: actor.id, movie_id: movie.id}
        |> Enum.into(@valid_attrs)
        |> Movies.create_role()

      role
    end

    test "list_roles/0 returns all roles" do
      role = role_fixture()
      assert Movies.list_roles() == [role]
    end

    test "get_role!/1 returns the role with given id" do
      role = role_fixture()
      assert Movies.get_role!(role.id) == role
    end

    test "create_role/1 with valid data creates a role" do
      actor = actor_fixture()
      movie = movie_fixture()

      assert {:ok, %Role{} = role} =
               Movies.create_role(
                 Map.merge(@valid_attrs, %{actor_id: actor.id, movie_id: movie.id})
               )

      assert role.character == "some character"
    end

    test "create_role/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Movies.create_role(@invalid_attrs)
    end

    test "update_role/2 with valid data updates the role" do
      role = role_fixture()
      assert {:ok, %Role{} = role} = Movies.update_role(role, @update_attrs)
      assert role.character == "some updated character"
    end

    test "update_role/2 with invalid data returns error changeset" do
      role = role_fixture()
      assert {:error, %Ecto.Changeset{}} = Movies.update_role(role, @invalid_attrs)
      assert role == Movies.get_role!(role.id)
    end

    test "delete_role/1 deletes the role" do
      role = role_fixture()
      assert {:ok, %Role{}} = Movies.delete_role(role)
      assert_raise Ecto.NoResultsError, fn -> Movies.get_role!(role.id) end
    end

    test "change_role/1 returns a role changeset" do
      role = role_fixture()
      assert %Ecto.Changeset{} = Movies.change_role(role)
    end
  end
end
