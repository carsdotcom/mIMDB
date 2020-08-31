defmodule Mimdb.Repo do
  use Ecto.Repo,
    otp_app: :mimdb,
    adapter: Ecto.Adapters.Postgres
end
