defmodule Banking.Users do
  @moduledoc """
  Handle with users operations
  """
  alias Ecto.Changeset
  alias Banking.Auth
  alias Banking.Accounts.User
  alias Banking.Accounts.Account
  alias Banking.Repo

  @doc """
  Create a new User with associated account
  """
  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Auth.hash_password()
    |> Changeset.put_assoc(:account, %Account{})
    |> Repo.insert()
  end
end
