defmodule BankingWeb.AccountController do
  use BankingWeb, :controller
  use BankingWeb.GuardedController

  alias Banking.Accounts

  action_fallback BankingWeb.FallbackController

  def withdraw(conn, %{"amount" => amount}, current_user) do
    case Accounts.validate_and_withdraw(current_user, amount) do
      {:ok, account} ->
        conn
        |> put_status(:created)
        |> render("withdraw.json", account: account)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(BankingWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
