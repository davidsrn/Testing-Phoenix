defmodule PhotosWeb.Router do
  use PhotosWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  defimpl Phoenix.HTML.Safe, for: Map do
    def to_iodata(data), do: data |> Poison.encode! |> Plug.HTML.html_escape
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Photos.Auth.Pipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", PhotosWeb do
    pipe_through [:browser, :auth]
    get "/user", PageController, :index
    post "/user", PageController, :login
    post "/logout", PageController, :logout
    resources "/", ImageController, only: [:index]
  end

  scope "/", PhotosWeb do
    pipe_through [:browser, :auth, :ensure_auth]
    get "/secret", PageController, :secret
    resources "/users", UserController
    resources "/images", ImageController

  end

  forward "/graphql",
  Absinthe.Plug,
  schema: PhotosWeb.Schema
  # For the GraphiQL interactive interface, a must-have for happy frontend devs.
  forward "/graphiql",
  Absinthe.Plug.GraphiQL,
  schema: PhotosWeb.Schema,
  interface: :simple

  # Other scopes may use custom stacks.
  # scope "/api", PhotosWeb do
  #   pipe_through :api
  # end
end
