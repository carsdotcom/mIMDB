defmodule MimdbWeb.RoleControllerTest do
  use MimdbWeb.ConnCase

  alias Mimdb.Movies

  @create_attrs %{character: "some character"}
  @update_attrs %{character: "some updated character"}
  @invalid_attrs %{character: nil}

  def fixture(:actor) do
    {:ok, actor} = Movies.create_actor(%{birthdate: ~D[2010-04-17], name: "some name"})
    actor
  end

  def fixture(:movie) do
    {:ok, movie} = Movies.create_movie(%{"release" => ~D[2010-04-17], "title" => "some title"})
    movie
  end

  def fixture(:role) do
    actor = fixture(:actor)
    movie = fixture(:movie)

    {:ok, role} =
      Movies.create_role(Map.merge(@create_attrs, %{actor_id: actor.id, movie_id: movie.id}))

    role
  end

  describe "index" do
    test "lists all roles", %{conn: conn} do
      conn = get(conn, Routes.role_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Roles"
    end
  end

  describe "new role" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.role_path(conn, :new, 1))
      assert html_response(conn, 200) =~ "New Role"
      assert html_response(conn, 200) =~ "Actors"
      assert html_response(conn, 200) =~ "<select"
    end
  end

  describe "create role" do
    test "redirects to show when data is valid", %{conn: conn} do
      actor = fixture(:actor)
      movie = fixture(:movie)

      conn =
        post(conn, Routes.role_path(conn, :create),
          role: Map.merge(@create_attrs, %{actor_id: actor.id, movie_id: movie.id})
        )

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.movie_path(conn, :edit, movie.id)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.role_path(conn, :create), role: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Role"
    end
  end

  describe "edit role" do
    setup [:create_role]

    test "renders form for editing chosen role", %{conn: conn, role: role} do
      conn = get(conn, Routes.role_path(conn, :edit, role))
      assert html_response(conn, 200) =~ "Edit Role"
    end
  end

  describe "update role" do
    setup [:create_role]

    test "redirects when data is valid", %{conn: conn, role: role} do
      conn = put(conn, Routes.role_path(conn, :update, role), role: @update_attrs)
      assert redirected_to(conn) == Routes.role_path(conn, :show, role)

      conn = get(conn, Routes.role_path(conn, :show, role))
      assert html_response(conn, 200) =~ "some updated character"
    end

    test "renders errors when data is invalid", %{conn: conn, role: role} do
      conn = put(conn, Routes.role_path(conn, :update, role), role: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Role"
    end
  end

  defp create_role(_) do
    role = fixture(:role)
    %{role: role}
  end
end
