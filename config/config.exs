# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :mimdb,
  ecto_repos: [Mimdb.Repo]

# Configures the endpoint
config :mimdb, MimdbWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "hW+t1YNwSBMWWbNrcH+1tZRUL6Ku754bv0nZL82aNLmWWARd4x44QAY712TLyeud",
  render_errors: [view: MimdbWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Mimdb.PubSub,
  live_view: [signing_salt: "1e3oMUbC"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
