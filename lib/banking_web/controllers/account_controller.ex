defmodule BankingWeb.AccountController do
  use BankingWeb, :controller

  alias Banking.Accounts

  action_fallback BankingWeb.FallbackController

  def withdraw(conn, %{"amount" => amount}) do
    current_user = Guardian.Plug.current_resource(conn)

    case Accounts.validate_and_withdraw(current_user, amount) do
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
  end

  def create_transfer(conn, %{"amount" => amount, "target" => target}) do
    current_user = Guardian.Plug.current_resource(conn)

    case Accounts.validates_and_transfers(current_user, target, amount) do
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
  end
end
