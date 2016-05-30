defmodule Skateboard.Router do
  use Skateboard.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Skateboard do
    pipe_through :browser # Use the default browser stack
    resources "/registrations", RegistrationController, only: [:new, :create]
    get    "/login",  SessionController, :new
    post   "/login",  SessionController, :create
    delete "/logout", SessionController, :delete
    get    "/lobby",  PageController, :index
    get    "/game",   PageController, :index
    get    "/",       PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", Skateboard do
  #   pipe_through :api
  # end
end
