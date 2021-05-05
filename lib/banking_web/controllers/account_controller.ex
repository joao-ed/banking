defmodule BankingWeb.AccountController do
  use BankingWeb, :controller

  alias Banking.Accounts

  action_fallback(BankingWeb.FallbackController)

  def withdraw(conn, %{"amount" => amount}) do
    current_user = Guardian.Plug.current_resource(conn)

    case user?(current_user) do
      {:ok, user} ->
        case Accounts.validate_and_withdraw(user, amount) do
          {:ok, value} ->
            conn
            |> put_status(:created)
            |> render("withdraw.json", account: value)

          {:error, :invalid_amount} ->
            conn
            |> put_status(:bad_request)
            |> render("error.json", error: "Invalid amount")

          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> render(BankingWeb.ChangesetView, "error.json", changeset: changeset)
        end

      {:error, :invalid_user} ->
        {:error, :unauthorized}
    end
  end

  def create_transfer(conn, %{"amount" => amount, "target" => target}) do
    current_user = Guardian.Plug.current_resource(conn)

    case user?(current_user) do
      {:ok, user} ->
        case Accounts.validates_and_transfers(user, target, amount) do
          {:ok, value} ->
            conn
            |> put_status(:created)
            |> render("transfers.json", %{
              from: current_user.email,
              to: target,
              amount: amount,
              balance: value.balance
            })

          {:error, :invalid_target} ->
            conn
            |> put_status(:bad_request)
            |> render("error.json", error: "Invalid target")

          {:error, :target_not_found} ->
            conn
            |> put_status(:bad_request)
            |> render("error.json", error: "Target not found")

          {:error, :invalid_amount} ->
            conn
            |> put_status(:bad_request)
            |> render("error.json", error: "Invalid amount")

          {:error, changeset} ->
            conn
            |> put_status(:bad_request)
            |> render(BankingWeb.ChangesetView, "error.json", changeset: changeset)
        end

      {:error, :invalid_user} ->
        {:error, :unauthorized}
    end
  end

  defp user?(user) when is_nil(user), do: {:error, :invalid_user}
  defp user?(user), do: {:ok, user}
end
