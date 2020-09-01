defmodule MimdbWeb.ActorViewTest do
  use MimdbWeb.ConnCase, async: true

  import Phoenix.View

  alias Mimdb.Actors
  alias MimdbWeb.ActorView

  @create_attrs %{birthdate: ~D[1956-07-09], name: "Tom Hanks"}

  test "return age" do
    date_fn = fn -> ~D[2020-07-09] end
    {:ok, actor} = Actors.create_actor(@create_attrs)

    assert ActorView.age(date_fn, actor) == 64
  end
end
