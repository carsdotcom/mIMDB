defmodule Mimdb.Movies do
  @moduledoc """
  The Movies context.
  """

  import Ecto.Query, warn: false
  alias Mimdb.Repo
  alias Mimdb.Movies.Genre
  alias Mimdb.Movies.Actor
  alias Mimdb.Movies.Rating
  alias Mimdb.Movies.Role
  @doc """
  Returns the list of genres.

  ## Examples

      iex> list_genres()
      [%Genre{}, ...]

  """
  def list_genres do
    Repo.all(from g in Genre, order_by: [asc: g.name])
  end

  @doc """
  Gets a single genre.

  Raises `Ecto.NoResultsError` if the Genre does not exist.

  ## Examples

      iex> get_genre!(123)
      %Genre{}

      iex> get_genre!(456)
      ** (Ecto.NoResultsError)

  """
  def get_genre!(id), do: Repo.get!(Genre, id)

  @doc """
  Creates a genre.

  ## Examples

      iex> create_genre(%{field: value})
      {:ok, %Genre{}}

      iex> create_genre(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_genre(attrs \\ %{}) do
    %Genre{}
    |> Genre.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a genre.

  ## Examples

      iex> update_genre(genre, %{field: new_value})
      {:ok, %Genre{}}

      iex> update_genre(genre, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_genre(%Genre{} = genre, attrs) do
    genre
    |> Genre.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a genre.

  ## Examples

      iex> delete_genre(genre)
      {:ok, %Genre{}}

      iex> delete_genre(genre)
      {:error, %Ecto.Changeset{}}

  """
  def delete_genre(%Genre{} = genre) do
    Repo.delete(genre)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking genre changes.

  ## Examples

      iex> change_genre(genre)
      %Ecto.Changeset{data: %Genre{}}

  """
  def change_genre(%Genre{} = genre, attrs \\ %{}) do
    Genre.changeset(genre, attrs)
  end

  @doc """
  Returns the list of actors.

  ## Examples

      iex> list_actors()
      [%Actor{}, ...]

  """
  def list_actors do
    Repo.all(from a in Actor, order_by: [asc: a.name])
  end

  @doc """
  Gets a single actor.

  Raises `Ecto.NoResultsError` if the Actor does not exist.

  ## Examples

      iex> get_actor!(123)
      %Actor{}

      iex> get_actor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_actor!(id), do: Repo.get!(Actor, id)

  @doc """
  Creates a actor.

  ## Examples

      iex> create_actor(%{field: value})
      {:ok, %Actor{}}

      iex> create_actor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_actor(attrs \\ %{}) do
    %Actor{}
    |> Actor.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
    Updates an actor
    ## Examples

    iex> update_actor(actor, %{field: new_value})
                             {:ok, %Actor{}}

    iex> update_actor(actor, %{field: bad_value})
            {:error, %Ecto.Changeset{}}
  """
  def update_actor(%Actor{} = actor, attrs) do
    actor
    |> Actor.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a actor.

  ## Examples

      iex> delete_actor(actor)
      {:ok, %Actor{}}

      iex> delete_actor(actor)
      {:error, %Ecto.Changeset{}}

  """
  def delete_actor(%Actor{} = actor) do
    try do
      Repo.delete(actor)
    rescue
      e in Ecto.ConstraintError ->  e
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking actor changes.

  ## Examples

      iex> change_actor(actor)
      %Ecto.Changeset{data: %Actor{}}

  """
  def change_actor(%Actor{} = actor, attrs \\ %{}) do
    Actor.changeset(actor, attrs)
  end

  alias Mimdb.Movies.Movie

  @doc """
  Returns the list of movies.

  ## Examples

      iex> list_movies()
      [%Movie{}, ...]

  """

  def list_movies(params, user_id) do
    search_genre_term = get_in(params, ["query"])
    query_sorted_movies(user_id)
    |> filter_by_genre(search_genre_term)
    |> order_by_title()
    |> Repo.all()
  end

  defp query_sorted_movies(user_id) do
    from(m in Movie,
      left_join: ratings in assoc(m, :ratings),
      distinct: m.id,
      where: ratings.user_id == ^user_id,
      or_where: m.id == ratings.movie_id,
      or_where: is_nil(ratings.movie_id),
      select: %Movie{ title: m.title, release: m.release, id: m.id,
                      ratings: %Rating{ value: ratings.value} }
    )
  end

  def filter_by_genre(q,nil) do
    q
  end

  def filter_by_genre(q,"0") do
    q
  end

  def filter_by_genre(q,search_genre_term) do
    search_genre_term = String.to_integer(search_genre_term)
    from m in q,
         left_join: g in assoc(m, :genres),
         where: g.id == ^search_genre_term
  end

  def order_by_title(q) do
    from m in q,
    order_by: [asc: m.title]
  end

  @doc """
  Gets a single movie.

  Raises `Ecto.NoResultsError` if the Movie does not exist.

  ## Examples

      iex> get_movie!(123)
      %Movie{}

      iex> get_movie!(456)
      ** (Ecto.NoResultsError)

  """
  def get_movie!(id) do
    Movie
    |> Repo.get!(id)
    |> Repo.preload(:genres)
  end

  def get_only_movie(id) do
    Repo.get!(Movie, id)
  end

  @doc """
  Creates a movie.

  ## Examples

      iex> create_movie(%{field: value})
      {:ok, %Movie{}}

      iex> create_movie(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_movie(attrs \\ %{}) do
    genres = get_genres(attrs["genres"])

    %Movie{}
    |> Movie.changeset(attrs, genres)
    |> Repo.insert()
  end

  def get_genres(nil) do
    []
  end

  def get_genres(genre_ids) do
    genre_ids
    |> Enum.map(fn x -> String.to_integer(x) end)
    |> query_genre_by_ids()
    |> Repo.all()
  end

  defp query_genre_by_ids(ids) do
    from(g in Genre, where: g.id in ^ids)
  end

  @doc """
  Updates a movie.

  ## Examples

      iex> update_movie(movie, %{field: new_value})
      {:ok, %Movie{}}

      iex> update_movie(movie, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_movie(%Movie{} = movie, attrs) do
    genres = get_genres(attrs["genres"])

    movie
    |> Movie.changeset(attrs, genres)
    |> Repo.update()
  end

  @doc """
  Deletes a movie.

  ## Examples

      iex> delete_movie(movie)
      {:ok, %Movie{}}

      iex> delete_movie(movie)
      {:error, %Ecto.Changeset{}}

  """
  def delete_movie(%Movie{} = movie) do
    delete_movie_roles(movie)
    delete_movie_ratings(movie)

    Repo.delete(movie)
  end

  def delete_movie_roles(movie) do
    from(r in Role, where: r.movie_id == ^movie.id)
    |> Repo.delete_all()
  end

  def delete_movie_ratings(movie) do
    from(r in Rating, where: r.movie_id == ^movie.id)
    |> Repo.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking movie changes.

  ## Examples

      iex> change_movie(movie)
      %Ecto.Changeset{data: %Movie{}}

  """
  def change_movie(%Movie{} = movie, attrs \\ %{}) do
    Movie.changeset(movie, attrs)
  end

  @doc """
  Returns the list of roles.

  ## Examples

      iex> list_roles()
      [%Role{}, ...]

  """
  def list_roles, do: Repo.all(from r in Role, order_by: [asc: r.character])

  def list_roles_for_movie_with_id(movie_id) do
    Repo.all(from(r in Role, where: r.movie_id == ^movie_id),
                             order_by: [asc: :character])
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end

  def rate_movie(params, user) do
    %Rating{ }
    |> Rating.changeset(%{movie_id: params["movie_id"], value: params["rating"], user_id: user.id  })
    |> Repo.insert(on_conflict: [set: [ value: params["rating"] ]], conflict_target: [:user_id, :movie_id])
  end

  def get_rating!(user_id, movie_id) do
    query_ratings(user_id, movie_id)
    |> Repo.all()
    |> List.first()
  end

  def query_ratings(user_id, movie_id) do
    from rating in Rating,
      where: rating.user_id == ^user_id,
      where: rating.movie_id == ^movie_id,
      select: rating
  end

  def delete_rating(%Rating{} = rating) do
    Repo.delete(rating)
  end

  def rating_average(movie) do
    from(r in Rating,
      select: type(avg(r.value), :float),
      where: r.movie_id == ^movie.id)
    |> Repo.one()
  end

  def rating_count(movie) do
    from(r in Rating,
      select: count(r),
      where: r.movie_id == ^movie.id)
    |> Repo.one()
  end
end
