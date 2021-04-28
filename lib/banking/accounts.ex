defmodule Banking.Accounts do
  @moduledoc """
  The account operations
  """
  alias Banking.Accounts.Account
  alias Banking.Repo

  @doc """
  Validate amount and withdraw money from user account
  """
  def validate_and_withdraw(user, amount) do
    case convert_amount(amount) do
      {:ok, value} ->
        Account
        |> Repo.get_by(user_id: user.id)
        |> withdraw(value)

      {:error, reason} ->
        {:error, reason}
    end
  end

  @doc """
  Transfer money to another account
  """
  def transfer(%Account{} = from, %Account{} = to, amount) do
    Repo.transaction(fn ->
      Repo.update!(Account.changeset(from, %{balance: from.balance - amount}))
      Repo.update!(Account.changeset(to, %{balance: to.balance + amount}))
    end)
  end

  defp withdraw(%Account{} = account, amount) do
    account
    |> Account.changeset(%{balance: account.balance - amount})
    |> IO.inspect()
    |> Repo.update()
  end

  defp convert_amount(amount) when is_binary(amount) do
    case Decimal.parse(amount) do
      {%Decimal{exp: -2, sign: 1} = decimal, ""} ->
        {:ok, decimal |> Decimal.mult(100) |> Decimal.to_integer()}

      _ ->
        {:error, "invalid_amount_format"}
    end
  end

  defp convert_amount(amount) when is_integer(amount) and amount > 0, do: {:ok, amount}
end
