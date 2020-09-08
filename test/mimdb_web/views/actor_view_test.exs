defmodule MimdbWeb.ActorViewTest do
  use MimdbWeb.ConnCase, async: true

  alias Mimdb.Movies
  alias MimdbWeb.ActorView

  @create_attrs %{birthdate: ~D[1956-07-09], name: "Tom Hanks"}

  test "return age" do
    {:ok, actor} = Movies.create_actor(@create_attrs)

    assert ActorView.age(actor) == 64
  end
end
