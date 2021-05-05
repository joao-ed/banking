# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :banking,
  ecto_repos: [Banking.Repo]

# Configures the endpoint
config :banking, BankingWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "2uhnnct0FjoE19dYvE46+ALqq846EZBfpzwpVBmYAuiLLxMe7MtqYEWwvQwRE7JT",
  render_errors: [view: BankingWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Banking.PubSub,
  live_view: [signing_salt: "U11QXJ/z"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures Guardian
config :banking, BankingWeb.Guardian,
  issuer: "banking",
  secret_key: "JW1haa1wBoL7MGqOJrzBP9LKbU5sikJtvdRJpjw+RF/DMP4EltvRJEjrAgi+geua"

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :pre_commit, commands: ["test", "credo"], verbose: true

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
