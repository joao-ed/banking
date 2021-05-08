defmodule Banking.AccountsTest do
  use Banking.DataCase, async: true

  alias Banking.Accounts
  alias Banking.Accounts.Account

  import Banking.Factory

  @target_user_attrs %{
    username: "Gidras, The Tyrant",
    email: "gidras@fakemail.com",
    password: "@4534J76a"
  }

  defp user_factory(%{user_attrs: user_attrs}),
    do: {:ok, user: insert!(:user_with_account, user_attrs)}

  defp user_factory(_context), do: {:ok, user: insert!(:user_with_account)}

  describe "finds_account_and_withdraw/2" do
    setup :user_factory

    test "should fail because account has insufficient funds", %{user: user} do
      {:error, changeset} = Accounts.finds_account_and_withdraw(user, 1000_01)
      assert %{balance: ["Insufficient funds to perform this operation"]} = errors_on(changeset)
    end

    test "withdraw money from user account", %{user: user} do
      {:ok, %{balance: balance}} = Accounts.finds_account_and_withdraw(user, 15_053)
      assert balance == 84_947
    end
  end

  describe "validates_and_transfers/3" do
    setup :user_factory

    test "should fail because account has insufficient funds", %{user: user} do
      %{email: target_email} = insert!(:user_with_account, @target_user_attrs)
      {:error, changeset} = Accounts.validates_and_transfers(user, target_email, 1000_01)

      assert %{balance: ["Insufficient funds to perform this operation"]} = errors_on(changeset)
    end

    test "should fail because target account does not exists", %{user: user} do
      assert {:error, :target_not_found} =
               Accounts.validates_and_transfers(user, "foo@fakemail.com", 100)
    end

    test "should fail because target account refers to same account", %{user: user} do
      assert {:error, :invalid_target} = Accounts.validates_and_transfers(user, user.email, 10_00)
    end

    test "should transfer amount to another account", %{user: user} do
      %{email: target_email} = insert!(:user_with_account, @target_user_attrs)

      {:ok, %Account{balance: balance_after_operation}} =
        Accounts.validates_and_transfers(user, target_email, 95_600)

      assert balance_after_operation == 44_00
    end
  end
end
