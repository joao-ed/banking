defmodule Banking.Factory do
  @moduledoc """
  A convinience for tests
  """

  alias Banking.Users.User
  alias Banking.Accounts.Account
  alias Banking.Repo

  @user_default_password "123456789"

  def build(:user_with_account) do
    %User{
      username: "Rob Halford",
      email: "rob@fakemail.com",
      password: @user_default_password,
      password_hash: Argon2.add_hash(@user_default_password).password_hash,
      account: %Account{balance: 100_000}
    }
  end

  def build(factory_name, attributes), do: factory_name |> build |> struct!(attributes)

  def insert!(factory_name, attributes \\ []) do
    subject =
      factory_name
      |> build(attributes)

    case Map.fetch(subject, :password) do
      {:ok, password} ->
        %{subject | password_hash: Argon2.add_hash(password).password_hash}
        |> Repo.insert!()

      :error ->
        subject |> Repo.insert!()
    end
  end
end
