defmodule TaskTrackerWeb.Router do
  use TaskTrackerWeb, :router

  import TaskTracker.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {TaskTrackerWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug TaskTracker.Auth.AccessPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", TaskTrackerWeb do
    pipe_through [:browser, :auth]

    get "/logout", SessionController, :logout
  end

  scope "/", TaskTrackerWeb do
    pipe_through [:browser, :auth, :redirect_if_user_is_authenticated]

    get "/login", SessionController, :new
    post "/login", SessionController, :login
  end

  scope "/", TaskTrackerWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/tasks/:id/complete", TaskController, :complete
    get "/tasks/shuffle", TaskController, :shuffle
    resources "/tasks", TaskController
  end

  # Other scopes may use custom stacks.
  # scope "/api", TaskTrackerWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TaskTrackerWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
