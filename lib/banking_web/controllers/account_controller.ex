defmodule BankingWeb.AccountController do
  use BankingWeb, :controller
  alias Banking.Auth

  def create(conn, params) do
    case Auth.register(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> text("User created!")

      {:error, changeset} ->
        render(conn, BankingWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
