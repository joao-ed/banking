defmodule BankingWeb.SessionController do
  use BankingWeb, :controller
  alias Banking.Users

  action_fallback(BankingWeb.FallbackController)

  def create(conn, params) do
    with {:ok, user} <- Users.find_user_and_check_password(params),
         {:ok, jwt, _full_claims} <- user |> BankingWeb.Guardian.encode_and_sign(%{}) do
      conn
      |> put_status(:created)
      |> render("login.json", jwt: jwt)
    else
      {:error, :user_not_found} ->
        conn
        |> put_status(:not_found)
        |> render("error.json", message: "User not found. Check your credentials and try again")

      {:error, reason} ->
        conn
        |> put_status(:unauthorized)
        |> render("error.json", message: reason)
    end
  end

  def auth_error(conn, {_type, _reason}, _opts) do
    conn
    |> put_status(:forbidden)
    |> put_view(BankingWeb.SessionView)
    |> render("error.json", message: "Not Authenticated")
  end
end
