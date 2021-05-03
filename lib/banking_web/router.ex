defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug(
      Guardian.Plug.Pipeline,
      error_handler: BankingWeb.SessionController,
      module: BankingWeb.Guardian
    )

    plug(Guardian.Plug.VerifyHeader)
    plug(Guardian.Plug.LoadResource, allow_blank: true)
  end

  scope "/api", BankingWeb do
    pipe_through :api
    post "/signin", SessionController, :create
    post "/accounts", UserController, :create
  end

  scope "/api", BankingWeb do
    pipe_through [:api, :auth]
    post "/signout", SessionController, :sign_out
  end

  scope "/api/accounts", BankingWeb do
    pipe_through [:api, :auth]
    get "/transfers", AccountController, :index
    post "/transfers", AccountController, :create_transfer
    post "/withdraw", AccountController, :withdraw
  end
end
