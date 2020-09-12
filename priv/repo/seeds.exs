# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Mimdb.Repo.insert!(%Mimdb.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Mimdb.Repo
import Ecto.Query, warn: false

defmodule Mimdb.Seeds.Users do
  # This is recreating functionality in Mimdb.UsersFixtures, but
  # I was struggling to get Users.Fixtures.user_fixture to work (module inaccessible)
  # My guess is that modules under /test are not in
  @number_of_users 10
  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def unique_user_name, do: "John#{System.unique_integer()} Doe"
  def valid_user_password, do: "blahblahblah"

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(%{
        email: unique_user_email(),
        name: unique_user_name(),
        password: valid_user_password()
      })
      |> Mimdb.Users.register_user()
    user
  end

  def create_users() do
    Enum.each(1..@number_of_users, fn _ -> user_fixture(%{}) end ) #could not figure out &user_fixture/1
    josh = user_fixture(name: "Josh Illian", email: "jillian@cars.com")
    eric = user_fixture(name: "Eric Thiele", email: "ethiele@cars.com")
    laura = user_fixture(name: "Laura Cordoba", email: "lcordoba-contractor@cars.com")
  end
end

defmodule Mimdb.Seeds.Genres do
  @genres  ["Action", "Adventure", "Biography", "Comedy", "Crime", "Documentary", "Drama",
            "History", "Mystery", "Romance", "War"]
  @date  NaiveDateTime.local_now()
  def set_a_genre(name) do
    [name: name, inserted_at: @date, updated_at: @date]
  end

  def create_genres do
    genres_list = Enum.map(@genres, &set_a_genre/1)
    Repo.insert_all(Mimdb.Movies.Genre, genres_list)
  end
end

defmodule Mimdb.Seeds.Actors do
  @actors [ %{name: "Joseph Cotten", birthdate: ~D[1905-05-15] },
            %{name: "Dorothy Comingore", birthdate: ~D[1913-08-24] },
            %{name: "Humphrey Bogart", birthdate: ~D[1899-12-25] },
            %{name: "Ingrid Bergman", birthdate: ~D[1915-08-29] },
            %{name: "Marlon Brando", birthdate: ~D[1924-04-03] },
            %{name: "Al Pacino", birthdate: ~D[1940-04-25] },
            %{name: "James Caan", birthdate: ~D[1940-03-26] },
            %{name: "Richard S. Castellano", birthdate: ~D[1933-09-04] },
            %{name: "Robert Duvall", birthdate: ~D[1931-01-05] },
            %{name: "Vivien Leigh", birthdate: ~D[1913-11-05]},
            %{name: "Clark Gable", birthdate: ~D[1901-02-01]},
            %{name: "Peter O'Toole", birthdate: ~D[1932-08-02]},
            %{name: "Alec Guiness", birthdate: ~D[1914-04-02]},
            %{name: "Anthony Quinn", birthdate: ~D[1915-04-21]},
            %{name: "Omar Sharif", birthdate: ~D[1932-04-10]}#,
#            %{name: "", birthdate: ~D[19-11-05]},
#            %{name: "", birthdate: ~D[19-11-05]},
#            %{name: "", birthdate: ~D[19-11-05]},
#            %{name: "", birthdate: ~D[19-11-05]},
  ]
  @date NaiveDateTime.local_now()

  def set_an_actor(attrs) do
    [name: attrs.name, birthdate: attrs.birthdate, inserted_at: @date, updated_at: @date]
  end

  def create_actors do
    actors_list = Enum.map(@actors, &set_an_actor/1)
    Repo.insert_all(Mimdb.Movies.Actor, actors_list)
  end
end


defmodule Mimdb.Seeds.Movies do
  @date NaiveDateTime.local_now()
  @movies  [
    %{title: "Citizen Kane", release: ~D[1941-09-05], genres: ["Drama", "Mystery"],
      roles: [%{character: "Jedediah Leland", actor: "Joseph Cotten" },
              %{character: "Susan Alexander Kane", actor: "Dorothy Comingore" }
      ]},
    %{title: "Casablanca", release: ~D[1942-01-23], genres: ["Drama", "Romance", "War"],
          roles: [%{character: "Rick Blaine", actor: "Humphrey Bogart" },
                  %{character: "Ilsa Lund", actor: "Ingrid Bergman" }
          ]},
    %{title: "The Godfather", release: ~D[1972-03-24], genres: ["Crime", "Drama"],
          roles: [%{character: "Don Vito Corleone", actor: "Marlon Brando" },
                  %{character: "Michael Corleone" , actor: "Al Pacino" },
                  %{character: "Sonny Corleone", actor: "James Caan" },
                  %{character: "Clemenza", actor: "Richard S. Castellano" },
                  %{character: "Tom Hagen", actor: "Robert Duvall" },
          ]},
    %{title: "Gone with the Wind", release: ~D[1940-01-17], genres: ["Drama", "History", "Romance"],
      roles: [%{character: "Scarlett O'Hara", actor: "Vivien Leigh"},
              %{character: "Rhett Butler", actor: "Clark Gable"}
    ]},
    %{title: "Lawrence of Arabia", release: ~D[1962-12-11], genres: ["Adventure", "Biography", "Drama"],
       roles: [%{character: "T.E. Lawrence", actor: "Peter O'Toole"},
               %{character: "Prince Faisal", actor: "Alec Guiness"},
               %{character: "Auda Abu Tayi", actor: "Anthony Quinn"},
               %{character: "Sherif Ali", actor: "Omar Sharif"}
                                                     ]}
]
#    %{title: "The Wizard of Oz", release: ~D[1939-01-01] },
#    %{title: "The Graduate", release: ~D[1967-01-01] },
#    %{title: "On The Waterfront", release: ~D[1954-01-01] },
#    %{title: "Schindler's List", release: ~D[1993-01-01] },
#    %{title: "Singin' in the Rain", release: ~D[1952-01-01] },
#    %{title: "It's a Wonderful Life", release: ~D[1946-01-01] },
#    %{title: "Sunset Boulevard", release: ~D[1950-01-01] },
#    %{title: "The Bridge on the River Kwai", release: ~D[1957-01-01] },
#    %{title: "Some Like it Hot", release: ~D[1959-01-01] },
#    %{title: "Star Wars", release: ~D[1977-01-01] },
#    %{title: "All About Eve", release: ~D[1950-01-01] },
#    %{title: "The African Queen", release: ~D[1951-01-01] },
#    %{title: "Psycho", release: ~D[1960-01-01] },
#    %{title: "The General", release: ~D[1926-01-01] },
#    %{title: "Chinatown", release: ~D[1974-01-01] },
#    %{title: "One Flew Over the Cuckoo's Nest", release: ~D[1975-01-01] }

  def set_a_movie(attrs) do
    genres = Enum.map(attrs.genres, fn n ->  Repo.get_by(Mimdb.Movies.Genre, name: n ) end )
    {:ok, movie} = Repo.insert(%Mimdb.Movies.Movie{title: attrs[:title], release: attrs[:release], genres: genres })
     create_roles_for_movie(movie, attrs.roles)
  end

  def set_role_to_movie(movie, attrs) do
    actor = Repo.get_by!(Mimdb.Movies.Actor, name: attrs.actor )
    [character: attrs.character, actor_id: actor.id, movie_id: movie.id, inserted_at: @date, updated_at: @date]
  end

  def create_roles_for_movie(movie, roles) do
    roles_list = Enum.map(roles, &set_role_to_movie(movie, &1))
    Repo.insert_all(Mimdb.Movies.Role, roles_list)
  end

  def create_movies do
    Enum.each(@movies, &set_a_movie/1)
  end

end

defmodule Mimdb.Seeds.Ratings do
  @date NaiveDateTime.local_now()
  def set_a_rating(user_id, movie_id) do
    [user_id: user_id, movie_id: movie_id, value: :rand.uniform(5),
      inserted_at: @date, updated_at: @date]
  end

  def create_ratings do
    movies = Repo.all(from m in Mimdb.Movies.Movie, select: m.id )
    users = Repo.all(from u in Mimdb.Users.User, select: u.id )
    Enum.each(users, fn u ->
      ratings_list = Enum.map(movies, &set_a_rating(u, &1))
      Repo.insert_all(Mimdb.Movies.Rating, ratings_list)
    end)
  end

end


alias Mimdb.Seeds.Users
alias Mimdb.Seeds.Genres
alias Mimdb.Seeds.Actors
alias Mimdb.Seeds.Movies
alias Mimdb.Seeds.Ratings

Users.create_users()
Genres.create_genres()
Actors.create_actors()
Movies.create_movies()
Ratings.create_ratings()
