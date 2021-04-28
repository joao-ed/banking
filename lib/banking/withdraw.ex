defmodule Banking.Withdraw do
  import Ecto.{Query, Changeset}, warn: false

  alias Banking.Repo
  alias Banking.User

  defp valid_amount?(balance, amount) do
    greater_than_zero?(amount) and sufficient_funds?(balance, amount)
  end

  defp greater_than_zero?(amount), do: amount > 0

  defp sufficient_funds?(balance, amount), do: balance - amount >= 0

  defp convert_amount(amount) when is_binary(amount) do
    case Decimal.parse(amount) do
      {%Decimal{exp: -2, sign: 1} = decimal, ""} ->
        {:ok, decimal |> Decimal.mult(100) |> Decimal.to_integer()}

      _ ->
        {:error, "invalid_amount_format"}
    end
  end

  defp convert_amount(amount) when is_integer(amount) and amount > 0, do: {:ok, amount}

  def validate_and_withdraw(user, amount) do
    %User{balance: balance} = user

    IO.inspect(convert_amount(amount))

    with {:ok, parsed_amount} <- convert_amount(amount),
         true <- valid_amount?(balance, parsed_amount) do
      Ecto.Changeset.change(user, %{balance: user.balance - parsed_amount})
      |> Repo.update()

      {:ok, "Withdraw: #{amount}"}
    else
      false -> {:error, "Invalid amount"}
      _ -> {:error, "Something went wrong"}
    end
  end
end
