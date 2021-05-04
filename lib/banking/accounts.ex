defmodule Banking.Accounts do
  @moduledoc """
  The Accounts context
  """
  alias Banking.Accounts.{Account, User}
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
  Validates target and amount, also transfers an amount to another account
  """
  def validates_and_transfers(user, target, amount) do
    with {:ok, value} <- convert_amount(amount),
         {:ok, target_user} <- {:ok, get_user_by_email(target)},
         {:ok, target_user} <- same_user?(user, target_user),
         {:ok, from} <- {:ok, get_account(user.id)},
         {:ok, to} <- {:ok, get_account(target_user.id)} do
      transfer(from, to, value)
    end
  end

  defp transfer(%Account{} = from, %Account{} = to, amount) do
    Repo.transaction(fn ->
      Repo.update(Account.changeset(to, %{balance: to.balance + amount}))
      Repo.update(Account.changeset(from, %{balance: from.balance - amount}))
    end)
  end

  defp withdraw(%Account{} = account, amount) do
    account
    |> Account.changeset(%{balance: account.balance - amount})
    |> Repo.update()
  end

  defp convert_amount(amount) when is_binary(amount) do
    case Decimal.parse(amount) do
      {%Decimal{exp: -2, sign: 1} = decimal, ""} ->
        {:ok, decimal |> Decimal.mult(100) |> Decimal.to_integer()}

      _ ->
        {:error, :invalid_amount}
    end
  end

  defp convert_amount(amount) when is_integer(amount) and amount > 0, do: {:ok, amount}

  defp get_user_by_email(email) do
    User
    |> Repo.get_by(email: email)
    |> Repo.preload(:account)
  end

  defp get_account(user_id), do: Repo.get_by!(Account, user_id: user_id)

  defp same_user?(current_user, target_user) when current_user.email !== target_user.email do
    {:ok, target_user}
  end

  defp same_user?(current_user, target_user) when current_user.email === target_user.email do
    {:error, :invalid_target}
  end

  defp same_user?(_current_user, target_user) when is_nil(target_user) do
    {:error, :target_not_found}
  end
end
