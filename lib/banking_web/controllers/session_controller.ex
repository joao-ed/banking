defmodule BankingWeb.SessionController do
  use BankingWeb, :controller
  alias Banking.Auth

  action_fallback(BankingWeb.FallbackController)

  def create(conn, params) do
    case Auth.find_user_and_check_password(params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} =
          user |> BankingWeb.Guardian.encode_and_sign(%{}, token_type: :bearer)

        conn
        |> put_status(:created)
        |> render("login.json", jwt: jwt)

      {:error, message} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", message: message)
    end
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:forbidden)
    |> render(BankingWeb.SessionView, "error.json", message: "Not Authenticated")
  end
end
