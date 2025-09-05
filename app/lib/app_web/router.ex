defmodule AppWeb.Router do
  use AppWeb, :router
  import Plug.BasicAuth

  pipeline :browser do
    plug :accepts, ["html"]
  end

  scope "/" do
    pipe_through :browser

    get "/docs", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
  end

  pipeline :auth do
    plug :basic_auth,
      username: Application.compile_env(:app, :auth)[:user],
      password: Application.compile_env(:app, :auth)[:password]
  end

  pipeline :openapi do
    plug OpenApiSpex.Plug.PutApiSpec, module: AppWeb.ApiSpec
  end

  scope "/api", AppWeb do
    pipe_through :api

    get "/health", HealthController, :check
  end

  scope "/api/oauth/providers", AppWeb do
    pipe_through [:api, :auth]

    get "/", OAuthController, :providers
    post "/:provider", OAuthController, :auth
    get "/:provider/auth_url", OAuthController, :auth_url
  end

  scope "/api" do
    pipe_through [:api, :openapi]

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:app, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: AppWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end

    scope "/api/oauth/providers", AppWeb do
      pipe_through :api

      get "/:provider/callback", OAuthController, :callback
    end
  end
end
