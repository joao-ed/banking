defmodule BankingWeb.WithdrawController do
  use BankingWeb, :controller
  use BankingWeb.GuardedController

  alias Banking.Withdraw

  action_fallback(BankingWeb.FallbackController)

  plug(Guardian.Plug.EnsureAuthenticated when action in [:withdraw])

  def withdraw(conn, %{"amount" => amount}, user) do
    case Withdraw.validate_and_withdraw(user, amount) do
      {:ok, message} ->
        render(conn, "index.json", %{message: message})

      {:error, message} ->
        conn
        |> put_status(:bad_request)
        |> render("error.json", %{message: message})
    end
  end
end
