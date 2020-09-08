defmodule MimdbWeb.RoleView do
  use MimdbWeb, :view

  def actor_select_options(actors) do
    actors
    |> Enum.map(&{&1.id, &1.name})
  end
end
