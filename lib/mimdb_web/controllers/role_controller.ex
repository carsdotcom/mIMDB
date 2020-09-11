defmodule MimdbWeb.RoleController do
  use MimdbWeb, :controller

  alias Mimdb.Movies
  alias Mimdb.Movies.Role

  def index(conn, _params) do
    roles = Movies.list_roles()
    render(conn, "index.html", roles: roles)
  end

  def new(conn, params) do
    changeset = Movies.change_role(%Role{movie_id: params["id"]})
    actors = Movies.list_actors()
    render(conn, "new.html", changeset: changeset, actors: actors)
  end

  def create(conn, %{"role" => role_params}) do
    case Movies.create_role(role_params) do
      {:ok, role} ->
        movie = Movies.get_movie!(role.movie_id)

        conn
        |> put_flash(:info, "Role created successfully.")
        |> redirect(to: Routes.movie_path(conn, :edit, movie))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)
        actors = Movies.list_actors()
        render(conn, "new.html", changeset: changeset, actors: actors)
    end
  end

  def show(conn, %{"id" => id}) do
    role = Movies.get_role!(id)
    render(conn, "show.html", role: role)
  end

  def edit(conn, %{"id" => id}) do
    role = Movies.get_role!(id)
    changeset = Movies.change_role(role)
    actors = Movies.list_actors()
    render(conn, "edit.html", role: role, changeset: changeset, actors: actors)
  end

  def update(conn, %{"id" => id, "role" => role_params}) do
    role = Movies.get_role!(id)

    case Movies.update_role(role, role_params) do
      {:ok, _role} ->
        conn
        |> put_flash(:info, "Role updated successfully.")
        |> redirect(to: Routes.role_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        actors = Movies.list_actors()
        render(conn, "edit.html", role: role, changeset: changeset, actors: actors)
    end
  end

  def delete(conn, %{"id" => id}) do
    role = Movies.get_role!(id)
    {:ok, _} = Movies.delete_role(role)

    conn
    |> put_flash(:info, "Role deleted successfully.")
    |> redirect(to: Routes.movie_path(conn, :edit, role.movie_id))
  end
end
