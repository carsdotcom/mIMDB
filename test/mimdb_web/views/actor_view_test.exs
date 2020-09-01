defmodule MimdbWeb.ActorViewTest do
  use MimdbWeb.ConnCase, async: true

  import Phoenix.View

  alias Mimdb.Actors
  alias MimdbWeb.ActorView

  @create_attrs %{birthdate: ~D[1956-07-09], name: "Tom Hanks"}

  test "show correct age" do
    {:ok, actor} = Actors.create_actor(@create_attrs)

    assert ActorView.age(~D[2020-09-01], actor) == 64
  end
end
