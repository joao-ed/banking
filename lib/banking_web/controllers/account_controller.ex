defmodule BankingWeb.AccountController do
  use BankingWeb, :controller

  alias Banking.Accounts

  action_fallback(BankingWeb.FallbackController)

  def withdraw(conn, %{"amount" => amount}) do
    case conn |> Guardian.Plug.current_resource() |> user? do
      {:ok, user} ->
        case convert_amount(amount) do
          {:ok, parsed_amount} ->
            case Accounts.finds_account_and_withdraw(user, parsed_amount) do
              {:ok, value} ->
                conn
                |> put_status(:created)
                |> render("withdraw.json", account: value)

              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render(BankingWeb.ChangesetView, "error.json", changeset: changeset)
            end

          {:error, :must_be_greater_or_equal_to_zero} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", error: "Invalid amount")

          {:error, :invalid_amount} ->
            conn
            |> put_status(:bad_request)
            |> render("error.json", error: "Invalid input")
        end

      {:error, :invalid_user} ->
        {:error, :unauthorized}
    end
  end

  def create_transfer(conn, %{"amount" => amount, "target" => target}) do
    case conn |> Guardian.Plug.current_resource() |> user? do
      {:ok, user} ->
        case convert_amount(amount) do
          {:ok, parsed_amount} ->
            case Accounts.validates_and_transfers(user, target, parsed_amount) do
              {:ok, value} ->
                conn
                |> put_status(:created)
                |> render("transfers.json", %{
                  from: user.email,
                  to: target,
                  amount: amount,
                  balance: value.balance
                })

              {:error, :invalid_target} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render("error.json", error: "Invalid target")

              {:error, :target_not_found} ->
                conn
                |> put_status(:unprocessable_entity)
                |> render("error.json", error: "Target not found")

              {:error, changeset} ->
                conn
                |> put_status(:unprocessable_entity)
                |> put_view(BankingWeb.ChangesetView)
                |> render("error.json", changeset: changeset)
            end

          {:error, :must_be_greater_or_equal_to_zero} ->
            conn
            |> put_status(:unprocessable_entity)
            |> render("error.json", error: "Invalid amount")

          {:error, :invalid_amount} ->
            conn
            |> put_status(:bad_request)
            |> render("error.json", error: "Invalid input")
        end

      {:error, :invalid_user} ->
        {:error, :unauthorized}
    end
  end

  defp convert_amount(amount) when is_binary(amount) do
    case Decimal.parse(amount) do
      {%Decimal{exp: -2, sign: 1} = decimal, ""} ->
        {:ok, decimal |> Decimal.mult(100) |> Decimal.to_integer()}

      _ ->
        {:error, :invalid_amount}
    end
  end

  defp convert_amount(amount) when is_float(amount), do: {:error, :invalid_amount}

  defp convert_amount(amount) when is_integer(amount) and amount > 0, do: {:ok, amount}

  defp convert_amount(amount) when is_integer(amount) and amount <= 0,
    do: {:error, :must_be_greater_or_equal_to_zero}

  defp user?(user) when is_nil(user), do: {:error, :invalid_user}
  defp user?(user), do: {:ok, user}
end
