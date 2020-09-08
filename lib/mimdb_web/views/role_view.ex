defmodule MimdbWeb.RoleView do
  use MimdbWeb, :view

  def actor_select_options(actors) do
    actors
    |> Enum.map(&{&1.name, &1.id})
  end
end
