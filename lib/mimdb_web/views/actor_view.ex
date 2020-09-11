defmodule MimdbWeb.ActorView do
  use MimdbWeb, :view

  def builder() do
    MimdbWeb.SharedView.builder()
  end

  def age(actor) do
    date =
      DateTime.now!("America/Chicago")
      |> DateTime.to_date()

    Kernel.trunc(Date.diff(date, actor.birthdate) / 365)
  end
end
