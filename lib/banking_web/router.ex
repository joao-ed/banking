defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]

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

    post("/accounts", AccountController, :create)
    post("/signin", SessionController, :create)
    resources("/transfers", TransfersController, only: [:index, :create])
    post("/withdraw", WithdrawController, :withdraw)
  end
end
