use Mix.Config

# Configure your database
config :banking, Banking.Repo,
  username: System.get_env("USER"),
  password: System.get_env("PASSWORD"),
  database: System.get_env("DATABASE"),
  hostname: System.get_env("HOSTNAME"),
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :banking, BankingWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []

# Watch static and templates for browser reloading.
config :banking, BankingWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/banking_web/(live|views)/.*(ex)$",
      ~r"lib/banking_web/templates/.*(eex)$"
    ]
  ]

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
