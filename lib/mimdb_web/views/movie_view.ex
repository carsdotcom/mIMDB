defmodule MimdbWeb.MovieView do
  use MimdbWeb, :view
  alias Mimdb.Movies

  def is_genre_selected(genre, changeset) do
    changeset.data.genres
    |> Enum.map(& &1.id)
    |> Enum.member?(genre.id)
  end

  def sort_movies(movies) do
    Enum.sort_by(movies, & &1.title)
  end

  def genre_select_options(genres) do
    genres
    |> Enum.map(&{&1.name, &1.id})
    |> List.insert_at(0, {"All", 0})
  end

  def builder() do
    fn select_for ->
      ~E"""
      <div class="flex">
        <div class="relative mr-2">
          <%= select_for.(:month, [class: "mt-1 block appearance-none w-full border border-gray-300 text-gray-700 py-2 px-4 pr-8 rounded-md leading-tight focus:outline-none focus:bg-white focus:border-blue-300"]) %>
          <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
            <svg class="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/></svg>
          </div>
        </div>
        <div class="relative mr-2">
          <%= select_for.(:day, [class: "mt-1 block appearance-none w-full border border-gray-300 text-gray-700 py-2 px-4 pr-8 rounded-md leading-tight focus:outline-none focus:bg-white focus:border-blue-300"]) %>
          <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
            <svg class="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/></svg>
          </div>
        </div>
        <div class="relative">
          <%= select_for.(:year, [class: "mt-1 block appearance-none w-full border border-gray-300 text-gray-700 py-2 px-4 pr-8 rounded-md leading-tight focus:outline-none focus:bg-white focus:border-blue-300"]) %>
          <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
            <svg class="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/></svg>
          </div>
        </div>
      </div>
      """
    end
  end

  def rated_value(current_user, movie) do
    Movies.get_rating!(current_user.id, movie.id)
    |> get_rating_value
  end

  def get_rating_value(nil) do
    0
  end

  def get_rating_value(rating) do
    rating.value
  end

  def get_rating_average(movie) do
    Movies.rating_average(movie) || 0
  end

  def get_rating_count(movie) do
    Movies.rating_count(movie)
  end
end
