defmodule BankingWeb.UserController do
  use BankingWeb, :controller
  alias Banking.Users

  action_fallback BankingWeb.FallbackController

  def create(conn, params) do
    case Users.register(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> render(BankingWeb.UserView, "user-created.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> render(BankingWeb.ChangesetView, "error.json", changeset: changeset)
    end
  end
end
