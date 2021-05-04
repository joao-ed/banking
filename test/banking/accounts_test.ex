defmodule Banking.AccountsTest do
  use Banking.DataCase, async: true

  alias Banking.{Accounts, Users}

  @user_attrs %{username: "foo", email: "bar@baz.com", password: "12345678"}

  def user_fixture(user_attrs) do
    {:ok, user} = Users.register(user_attrs)
    user
  end

  test "validate_and_withdraw/2 with invalid amount (zero as binary)" do
    user = user_fixture(@user_attrs)
    assert {:error, :invalid_amount} = Accounts.validate_and_withdraw(user, "0")
  end

  test "validate_and_withdraw/2 with invalid amount (zero as integer)" do
    user = user_fixture(@user_attrs)
    assert {:error, :invalid_amount} = Accounts.validate_and_withdraw(user, 0)
  end

  test "validate_and_withdraw/2 with valid amount" do
    user = user_fixture(@user_attrs)
    assert {:ok, %{balance: new_balance}} = Accounts.validate_and_withdraw(user, "100.00")
    assert new_balance === 900_00
  end
end
