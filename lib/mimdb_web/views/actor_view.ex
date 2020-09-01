defmodule MimdbWeb.ActorView do
  use MimdbWeb, :view

  def age(date_fn, actor) do
    Kernel.trunc(Date.diff(date_fn.(), actor.birthdate) / 365)
  end
end
