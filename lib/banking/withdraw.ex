defmodule Banking.Withdraw do
  import Ecto.{Query, Changeset}, warn: false

  alias Banking.Repo
  alias Banking.User

  def valid_amount?(balance, amount) do
    greater_than_zero?(amount) and sufficient_funds?(balance, amount)
  end

  def greater_than_zero?(amount), do: amount > 0

  def sufficient_funds?(balance, amount), do: balance - amount >= 0

  def validate_and_withdraw(user, amount) do
    %User{balance: balance} = user

    case valid_amount?(balance, amount) do
      true ->
        Ecto.Changeset.change(user, %{balance: user.balance - amount})
        |> Repo.update()

        {:ok, "Withdraw: #{amount}"}

      false ->
        {:error, "Invalid amount"}
    end
  end
end
