# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :photos,
  ecto_repos: [Photos.Repo]

  config :photos, Photos.Auth.Guardian,
    issuer: "photos", # Name of your app/company/product
    secret_key: "BXxYD3s++wFYGaudWOsCz4Sk+pUhRFB7+RiW+BINp9x6RbjmYUxAJI1k5c5TGAtw" # Replace this with the output of the mix command

# Configures the endpoint
config :photos, PhotosWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "MMelKshowvH3Fbx0ly5Pue6kaOpJZm8TZf3RpEEJoB54qGrhfffbZ5CFGKUPrEYQ",
  render_errors: [view: PhotosWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Photos.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configure Arc
config :arc,
  storage: Arc.Storage.Local

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
