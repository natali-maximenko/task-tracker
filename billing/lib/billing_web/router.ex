defmodule BillingWeb.Router do
  use BillingWeb, :router
  import Billing.Auth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {BillingWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug Billing.Auth.AccessPipeline
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  scope "/", BillingWeb do
    pipe_through [:browser, :auth]

    get "/logout", SessionController, :logout
  end

  scope "/", BillingWeb do
    pipe_through [:browser, :auth, :redirect_if_user_is_authenticated]

    get "/login", SessionController, :new
    post "/login", SessionController, :login
  end

  scope "/", BillingWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    # protected
  end

  scope "/", BillingWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", BillingWeb do
  #   pipe_through :api
  # end

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
