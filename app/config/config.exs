# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :app,
  ecto_repos: [App.Repo],
  generators: [timestamp_type: :utc_datetime]

# Configures the endpoint
config :app, AppWeb.Endpoint,
  url: [host: System.get_env("HOST", "localhost"), scheme: "https"],
  adapter: Bandit.PhoenixAdapter,
  render_errors: [
    formats: [json: AppWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: App.PubSub,
  live_view: [signing_salt: "88tspGlx"]

# Configures the mailer
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :app, App.Mailer, adapter: Swoosh.Adapters.Local

# Configures Elixir's Logger
config :logger, :default_formatter,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :app, :google,
  client_id: System.get_env("GOOGLE_CLIENT_ID"),
  client_secret: System.get_env("GOOGLE_CLIENT_SECRET"),
  redirect_uri: System.get_env("GOOGLE_OAUTH_REDIRECT_URI")

config :app, :redis,
  host: System.get_env("REDIS_HOST"),
  port: System.get_env("REDIS_PORT")

config :app, :auth,
  user: System.get_env("API_USER"),
  password: System.get_env("API_PASSWORD")

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
