defmodule Banking.Accounts do
  @moduledoc """
  The Accounts context
  """
  alias Banking.Accounts.Account
  alias Banking.Repo
  alias Banking.Users.User

  @doc """
  Finds user account and withdraw money
  """
  def finds_account_and_withdraw(%{id: user_id}, amount) do
    Account
    |> Repo.get_by(user_id: user_id)
    |> withdraw(amount)
  end

  @doc """
  Validates target and amount, also transfers an amount to another account
  """
  def validates_and_transfers(user, target, amount) do
    with {:ok, target_user} <- {:ok, get_user_by_email(target)},
         {:ok, target_user} <- same_user?(user, target_user),
         {:ok, from} <- {:ok, get_account(user.id)},
         {:ok, to} <- {:ok, get_account(target_user.id)} do
      transfer(from, to, amount)
    end
  end

  defp transfer(%Account{} = from, %Account{} = to, amount) do
    {:ok, result} =
      Repo.transaction(fn ->
        Repo.update(Account.changeset(to, %{balance: to.balance + amount}))
        Repo.update(Account.changeset(from, %{balance: from.balance - amount}))
      end)

    result
  end

  defp withdraw(%Account{} = account, amount) do
    account
    |> Account.changeset(%{balance: account.balance - amount})
    |> Repo.update()
  end

  defp get_user_by_email(email) do
    User
    |> Repo.get_by(email: email)
    |> Repo.preload(:account)
  end

  defp get_account(user_id), do: Repo.get_by!(Account, user_id: user_id)

  defp same_user?(current_user, target_user) when current_user.email != target_user.email do
    {:ok, target_user}
  end

  defp same_user?(current_user, target_user) when current_user.email == target_user.email do
    {:error, :invalid_target}
  end

  defp same_user?(_current_user, target_user) when is_nil(target_user) do
    {:error, :target_not_found}
  end
end
