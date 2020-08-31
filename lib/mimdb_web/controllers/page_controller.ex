defmodule MimdbWeb.PageController do
  use MimdbWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
