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
date = NaiveDateTime.local_now()
#  DateTime.now!("America/Chicago")
#  |> NaiveDateTime.to_time()
genres = ["Action", "Comedy", "Documentary", "Drama", "Romance", "War"]
genres_list = Enum.map(genres, fn n -> [name: n, inserted_at: date, updated_at: date] end)
Mimdb.Repo.insert_all(Mimdb.Movies.Genre, genres_list)

actors = ["Tom Hanks", "Sandra Bullock", "Al Pacino"]
actors_list = Enum.map(actors, fn n -> [name: n, birthdate: ~D[1967-04-17] , inserted_at: date, updated_at: date] end)
Mimdb.Repo.insert_all(Mimdb.Movies.Actor, actors_list)