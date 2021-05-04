defmodule Banking.Accounts.AccountTest do
  use Banking.DataCase, async: true
  alias Banking.Accounts.Account

  test "balance must be equal or greater than zero" do
    changeset = Account.changeset(%Account{}, %{balance: -1})
    assert %{balance: ["Insufficient funds to perform this operation"]} = errors_on(changeset)
  end
end
