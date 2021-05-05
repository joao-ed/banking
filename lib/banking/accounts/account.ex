defmodule Banking.Accounts.Account do
  @moduledoc """
  The Account model
  """
  use Ecto.Schema
  import Ecto.Changeset
  alias Banking.Users.User

  @initial_balance 100_000

  schema "accounts" do
    field(:balance, :integer, required: true, default: @initial_balance)
    belongs_to(:user, User)
    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:balance])
    |> foreign_key_constraint(:user_id)
    |> validate_number(:balance,
      greater_than_or_equal_to: 0,
      message: "Insufficient funds to perform this operation"
    )
  end
end
