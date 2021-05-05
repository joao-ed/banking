defmodule Banking.AccountsTest do
  use Banking.DataCase, async: true

  alias Banking.{Accounts, Users}
  alias Banking.Accounts.Account

  @user_attrs %{
    username: "ldriss, The Strong",
    email: "idriss@fakemail.com",
    password: "12345678"
  }
  @target_user_attrs %{
    username: "Gidras, The Tyrant",
    email: "gidras@fakemail.com",
    password: "@4534J76a"
  }

  def user_fixture(user_attrs) do
    {:ok, user} = Users.register(user_attrs)
    user
  end

  describe "validate_and_withdraw/2 with invalid amount" do
    test "(zero as binary)" do
      user = user_fixture(@user_attrs)
      assert {:error, :invalid_amount} = Accounts.validate_and_withdraw(user, "0")
    end

    test "(zero as integer)" do
      user = user_fixture(@user_attrs)
      assert {:error, :invalid_amount} = Accounts.validate_and_withdraw(user, 0)
    end

    test "(negative amount)" do
      user = user_fixture(@user_attrs)
      assert {:error, :invalid_amount} = Accounts.validate_and_withdraw(user, "-110.23")
    end

    test "(insufficient funds)" do
      user = user_fixture(@user_attrs)
      {:error, changeset} = Accounts.validate_and_withdraw(user, "1000.02")
      assert %{balance: ["Insufficient funds to perform this operation"]} = errors_on(changeset)
    end
  end

  test "validate_and_withdraw/2 with valid amount" do
    user = user_fixture(@user_attrs)
    assert {:ok, %{balance: new_balance}} = Accounts.validate_and_withdraw(user, "100.00")
    assert new_balance === 900_00
  end

  test "validate_and_withdraw/2 with valid amount (decimal)" do
    user = user_fixture(@user_attrs)
    assert {:ok, %{balance: new_balance}} = Accounts.validate_and_withdraw(user, "147.37")
    assert new_balance === 852_63
  end

  describe "validates_and_transfers/3 with invalid arguments" do
    test "(negative amount)" do
      user = user_fixture(@user_attrs)
      target_user = user_fixture(@target_user_attrs)

      assert {:error, :invalid_amount} =
               Accounts.validates_and_transfers(user, target_user.email, "-13.45")
    end

    test "(insufficent funds)" do
      user = user_fixture(@user_attrs)
      target_user = user_fixture(@target_user_attrs)
      {:error, changeset} = Accounts.validates_and_transfers(user, target_user.email, "1000.01")

      assert %{balance: ["Insufficient funds to perform this operation"]} = errors_on(changeset)
    end

    test "(target refers to same user)" do
      user = user_fixture(@user_attrs)

      assert {:error, :invalid_target} =
               Accounts.validates_and_transfers(user, user.email, "10.00")
    end

    test "(target not found)" do
      user = user_fixture(@user_attrs)

      assert {:error, :target_not_found} =
               Accounts.validates_and_transfers(user, "foo@fakemail.com", "1.00")
    end
  end

  test "validates_and_transfers/3 with valid arguments" do
    user = user_fixture(@user_attrs)
    target_user = user_fixture(@target_user_attrs)

    assert {:ok, %Account{balance: balance_after_operation}} =
             Accounts.validates_and_transfers(user, target_user.email, "956.00")

    assert balance_after_operation === 44_00
  end
end
