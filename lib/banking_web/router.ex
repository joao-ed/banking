defmodule BankingWeb.Router do
  use BankingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    # plug :fetch_session
    # plug :fetch_flash
    # plug :protect_from_forgery
    # plug :put_secure_browser_headers
  end


  scope "/api", BankingWeb do
    pipe_through :api

    post("/accounts", AccountController, :create)
    post("/signin", SessionController, :create)
    resources("/transfers", TransfersController, only: [:index, :create])
    post("/withdraw", WithdrawController, :create)
  end

end
