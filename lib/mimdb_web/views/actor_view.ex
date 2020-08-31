defmodule MimdbWeb.ActorView do
  use MimdbWeb, :view

  def age(actor) do
    Kernel.trunc(Date.diff(Date.utc_today, actor.birthdate) / 365)
  end
end
