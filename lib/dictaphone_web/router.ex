defmodule DictaphoneWeb.Router do
  use DictaphoneWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {DictaphoneWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DictaphoneWeb do
    pipe_through :browser

    live "/", Dictaphone

    resources "/clips", ClipController
  end

  # Other scopes may use custom stacks.
  # scope "/api", DictaphoneWeb do
  #   pipe_through :api
  # end

  scope "/audio", DictaphoneWeb do
    get "/:name", AudioController, :get
    put "/:name", AudioController, :put
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:dictaphone, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: DictaphoneWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
