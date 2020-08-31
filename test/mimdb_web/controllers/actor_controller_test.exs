defmodule MimdbWeb.ActorControllerTest do
  use MimdbWeb.ConnCase

  alias Mimdb.Actors

  @create_attrs %{birthdate: ~D[2010-04-17], name: "some name"}
  @update_attrs %{birthdate: ~D[2011-05-18], name: "some updated name"}
  @invalid_attrs %{birthdate: nil, name: nil}

  def fixture(:actor) do
    {:ok, actor} = Actors.create_actor(@create_attrs)
    actor
  end

  describe "index" do
    test "lists all actors", %{conn: conn} do
      conn = get(conn, Routes.actor_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Actors"
    end
  end

  describe "new actor" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.actor_path(conn, :new))
      assert html_response(conn, 200) =~ "New Actor"
    end
  end

  describe "create actor" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.actor_path(conn, :create), actor: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.actor_path(conn, :show, id)

      conn = get(conn, Routes.actor_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Actor"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.actor_path(conn, :create), actor: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Actor"
    end
  end

  describe "edit actor" do
    setup [:create_actor]

    test "renders form for editing chosen actor", %{conn: conn, actor: actor} do
      conn = get(conn, Routes.actor_path(conn, :edit, actor))
      assert html_response(conn, 200) =~ "Edit Actor"
    end
  end

  describe "update actor" do
    setup [:create_actor]

    test "redirects when data is valid", %{conn: conn, actor: actor} do
      conn = put(conn, Routes.actor_path(conn, :update, actor), actor: @update_attrs)
      assert redirected_to(conn) == Routes.actor_path(conn, :show, actor)

      conn = get(conn, Routes.actor_path(conn, :show, actor))
      assert html_response(conn, 200) =~ "some updated name"
    end

    test "renders errors when data is invalid", %{conn: conn, actor: actor} do
      conn = put(conn, Routes.actor_path(conn, :update, actor), actor: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Actor"
    end
  end

  describe "delete actor" do
    setup [:create_actor]

    test "deletes chosen actor", %{conn: conn, actor: actor} do
      conn = delete(conn, Routes.actor_path(conn, :delete, actor))
      assert redirected_to(conn) == Routes.actor_path(conn, :index)
      assert_error_sent 404, fn ->
        get(conn, Routes.actor_path(conn, :show, actor))
      end
    end
  end

  defp create_actor(_) do
    actor = fixture(:actor)
    %{actor: actor}
  end
end
