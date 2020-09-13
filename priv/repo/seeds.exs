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
  # TODO: optimize this so that it's an insert_all rather than using register_user which takes a while
  @number_of_users 20
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
    mike = user_fixture(name: "Mike Ratliff", email: "mratliff-contractor@cars.com")
  end
end

defmodule Mimdb.Seeds.Genres do
  @genres  ~w(Action Adventure Biography Comedy Crime Documentary Drama Family Fantasy Film-Noir History Horror Music Musical Mystery Romance Thriller War)s
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
            %{name: "Alec Guinness", birthdate: ~D[1914-04-02]},
            %{name: "Anthony Quinn", birthdate: ~D[1915-04-21]},
            %{name: "Omar Sharif", birthdate: ~D[1932-04-10]},
            %{name: "Judy Garland", birthdate: ~D[1922-06-10]},
            %{name: "Frank Morgan", birthdate: ~D[1890-06-01]},
            %{name: "Ray Bolger", birthdate: ~D[1904-01-10]},
            %{name: "Bert Lahr", birthdate: ~D[1895-08-13]},
            %{name: "Jack Haley", birthdate: ~D[1897-08-10]},
            %{name: "Margaret Hamilton", birthdate: ~D[1902-12-09]},
            %{name: "Anne Bancroft", birthdate: ~D[1931-09-17]},
            %{name: "Dustin Hoffman", birthdate: ~D[1937-08-08]},
            %{name: "Liam Neeson", birthdate: ~D[1952-06-07]},
            %{name: "Ben Kingsley", birthdate: ~D[1943-12-31]},
            %{name: "Ralph Fiennes", birthdate: ~D[1962-12-22]},
            %{name: "Gene Kelly", birthdate: ~D[1912-08-23]},
            %{name: "Donald O'Connor", birthdate: ~D[1925-08-28]},
            %{name: "Debbie Reynolds", birthdate: ~D[1932-04-01]},
            %{name: "James Stewart", birthdate: ~D[1908-05-20]},
            %{name: "Donna Reed", birthdate: ~D[1921-01-27]},
            %{name: "Lionel Barrymore", birthdate: ~D[1878-04-28]},
            %{name: "William Holden", birthdate: ~D[1918-04-17]},
            %{name: "Marilyn Monroe", birthdate: ~D[1926-06-01]},
            %{name: "Tony Curtis", birthdate: ~D[1925-06-03]},
            %{name: "Jack Lemmon", birthdate: ~D[1925-02-08]},
            %{name: "Mark Hamill", birthdate: ~D[1951-09-25]},
            %{name: "Harrison Ford", birthdate: ~D[1942-07-13]},
            %{name: "Carrie Fisher", birthdate: ~D[1956-10-21]},
            %{name: "Peter Cushing", birthdate: ~D[1913-05-26]},
            %{name: "Anthony Daniels", birthdate: ~D[1946-02-21]},
            %{name: "Kenny Baker", birthdate: ~D[1934-08-24]},
            %{name: "Peter Mayhew", birthdate: ~D[1944-05-19]},
            %{name: "David Prowse", birthdate: ~D[1935-07-01]},
            %{name: "Katharine Hepburn", birthdate: ~D[1907-05-12]},
            %{name: "Anthony Perkins", birthdate: ~D[1932-04-04]},
            %{name: "Vera Miles", birthdate: ~D[1929-08-23]},
            %{name: "Jack Nicholson", birthdate: ~D[1937-04-22]},
            %{name: "Faye Dunaway", birthdate: ~D[1941-01-14]}
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
    %{title: "Citizen Kane", release: ~D[1941-09-05], genres: ~w(Drama Mystery),
      roles: [%{character: "Jedediah Leland", actor: "Joseph Cotten" },
              %{character: "Susan Alexander Kane", actor: "Dorothy Comingore" }
      ]},
    %{title: "Casablanca", release: ~D[1942-01-23], genres: ~w(Drama Romance War),
          roles: [%{character: "Rick Blaine", actor: "Humphrey Bogart" },
                  %{character: "Ilsa Lund", actor: "Ingrid Bergman" }
          ]},
    %{title: "The Godfather", release: ~D[1972-03-24], genres: ~w(Crime Drama),
          roles: [%{character: "Don Vito Corleone", actor: "Marlon Brando" },
                  %{character: "Michael Corleone" , actor: "Al Pacino" },
                  %{character: "Sonny Corleone", actor: "James Caan" },
                  %{character: "Clemenza", actor: "Richard S. Castellano" },
                  %{character: "Tom Hagen", actor: "Robert Duvall" },
          ]},
    %{title: "Gone with the Wind", release: ~D[1940-01-17], genres: ~w(Drama History Romance),
      roles: [%{character: "Scarlett O'Hara", actor: "Vivien Leigh"},
              %{character: "Rhett Butler", actor: "Clark Gable"}
    ]},
    %{title: "Lawrence of Arabia", release: ~D[1962-12-11], genres: ~w(Adventure Biography Drama),
       roles: [%{character: "T.E. Lawrence", actor: "Peter O'Toole"},
               %{character: "Prince Faisal", actor: "Alec Guinness"},
               %{character: "Auda Abu Tayi", actor: "Anthony Quinn"},
               %{character: "Sherif Ali", actor: "Omar Sharif"}]
    },
    %{title: "The Wizard of Oz", release: ~D[1939-08-25], genres: ~w(Adventure Family Fantasy),
      roles: [%{character: "Dorothy", actor: "Judy Garland"},
              %{character: "The Wizard of Oz", actor: "Frank Morgan"},
              %{character: "The Scarecrow", actor: "Ray Bolger"},
              %{character: "The Cowardly Lion", actor: "Bert Lahr"},
              %{character: "The Tin Man", actor: "Jack Haley"},
              %{character: "The Wicked Witch of the West", actor: "Margaret Hamilton"},
             ]
    },
    %{title: "The Graduate", release: ~D[1967-12-21], genres: ~w(Comedy Drama Romance),
      roles: [%{character: "Mrs. Robinson", actor: "Anne Bancroft"},
              %{character: "Ben Braddock", actor: "Dustin Hoffman"}
              ]
     },
   %{title: "On The Waterfront", release: ~D[1954-06-22], genres: ~w(Crime Drama Thriller),
     roles: [%{character: "Terry Malloy", actor: "Marlon Brando"}]
   },
    %{title: "Schindler's List", release: ~D[1994-02-04], genres: ~w(Biography Drama History),
      roles: [%{character: "Oskar Schindler", actor: "Liam Neeson"},
              %{character: "Itzhak Stern", actor: "Ben Kingsley"},
              %{character: "Amon Goeth", actor: "Ralph Fiennes"}]
     },
    %{title: "Singin' in the Rain", release: ~D[1952-04-11], genres: ~w(Comedy Musical Romance),
      roles: [%{character: "Don Lockwood", actor: "Gene Kelly"},
              %{character: "Cosmo Brown", actor: "Donald O'Connor"},
              %{character: "Kathy Selden", actor: "Debbie Reynolds"}]
     },
    %{title: "It's a Wonderful Life", release: ~D[1947-01-07], genres: ~w(Drama Family Fantasy),
      roles: [%{character: "George Bailey", actor: "James Stewart"},
              %{character: "Mary Hatch", actor: "Donna Reed"},
              %{character: "Mr. Potter", actor: "Lionel Barrymore"}]
      },
    %{title: "Sunset Boulevard", release: ~D[1950-09-29], genres: ~w(Drama Film-Noir), roles: []  },
    %{title: "The Bridge on the River Kwai", release: ~D[1957-01-01], genres: ~w(Adventure Drama War),
      roles: [%{character: "Shears", actor: "William Holden"},
              %{character: "Colonel Nicholson", actor: "Alec Guinness"}]
      },
    %{title: "Some Like it Hot", release: ~D[1959-03-19], genres: ~w(Comedy Music Romance),
      roles: [%{character: "Sugar Kane Kowalczyk", actor: "Marilyn Monroe"},
              %{character: "Joe", actor: "Tony Curtis"},
              %{character: "Jerry", actor: "Jack Lemmon"}]
      },
    %{title: "Star Wars: Episode IV", release: ~D[1977-05-25], genres: ~w(Action Adventure Fantasy),
      roles: [%{character: "Luke Skywalker", actor: "Mark Hamill"},
              %{character: "Han Solo", actor: "Harrison Ford"},
              %{character: "Princess Leia Organa", actor: "Carrie Fisher"},
              %{character: "Grand Moff Tarkin", actor: "Peter Cushing"},
              %{character: "Ben Obi-Wan Kenobi", actor: "Alec Guinness"},
              %{character: "C-3PO", actor: "Anthony Daniels"},
              %{character: "R2-D2", actor: "Kenny Baker"},
              %{character: "Chewbacca", actor: "Peter Mayhew"},
              %{character: "Darth Vader", actor: "David Prowse"}]
    },
    %{title: "All About Eve", release: ~D[1950-10-27], genres: ~w(Drama), roles: []},
    %{title: "The African Queen", release: ~D[1952-03-21], genres: ~w(Adventure Drama Romance),
      roles: [%{character: "Charlie Allnutt", actor: "Humphrey Bogart"},
              %{character: "Rose Sayer", actor: "Katharine Hepburn"}]
     },
    %{title: "Psycho", release: ~D[1960-01-01], genres: ~w(Horror Mystery Thriller),
      roles: [%{character: "Norman Bates", actor: "Anthony Perkins"},
              %{character: "Lila Crane", actor: "Vera Miles"}]
     },
    %{title: "The General", release: ~D[1927-01-02], genres: ~w(Action Adventure Comedy), roles: [] },
    %{title: "Chinatown", release: ~D[1974-01-01], genres: ~w(Drama Mystery Thriller),
      roles: [%{character: "J.J. Gittes", actor: "Jack Nicholson"},
              %{character: "Evelyn Mulwray", actor: "Faye Dunaway"}]
     },
    %{title: "One Flew Over the Cuckoo's Nest", release: ~D[1975-01-01], genres: ~w(Drama),
      roles: [%{character: "R.P. McMurphy", actor: "Jack Nicholson"}]
     }
]
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


alias Mimdb.Seeds.{Users, Genres, Actors, Movies, Ratings}

Users.create_users()
Genres.create_genres()
Actors.create_actors()
Movies.create_movies()
Ratings.create_ratings()
