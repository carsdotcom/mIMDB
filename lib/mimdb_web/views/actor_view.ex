defmodule MimdbWeb.ActorView do
  use MimdbWeb, :view

  def age(date, actor) do
    Kernel.trunc(Date.diff(date, actor.birthdate) / 365)
  end
end
