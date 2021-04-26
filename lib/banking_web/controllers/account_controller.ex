defmodule BankingWeb.AccountController do
  use BankingWeb, :controller
  alias Banking.Auth

  action_fallback(BankingWeb.FallbackController)

  def create(conn, params) do
    case Auth.register(params) do
      {:ok, _user} ->
        conn
        |> put_status(:created)
        |> text("User created!")

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(BankingWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
