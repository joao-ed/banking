defmodule BankingWeb.UserController do
  use BankingWeb, :controller
  alias Banking.Users

  action_fallback BankingWeb.FallbackController

  def create(conn, params) do
    case Users.register(params) do
      {:ok, user} ->
        conn
        |> put_status(:created)
        |> put_view(BankingWeb.UserView)
        |> render("user-created.json", user: user)

      {:error, changeset} ->
        conn
        |> put_status(:bad_request)
        |> put_view(BankingWeb.ChangesetView)
        |> render("error.json", changeset: changeset)
    end
  end
end
