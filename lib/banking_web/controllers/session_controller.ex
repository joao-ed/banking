defmodule BankingWeb.SessionController do
  use BankingWeb, :controller
  alias Banking.Auth

  action_fallback(BankingWeb.FallbackController)

  def create(conn, params) do
    case Auth.find_user_and_check_password(params) do
      {:ok, user} ->
        json(conn, %{ok: "authenticated!"})

      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> render(BankingWeb.UserView, "error.json", message: message)
    end
  end
end
