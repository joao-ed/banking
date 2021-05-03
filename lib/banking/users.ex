defmodule Banking.Users do
  @moduledoc """
  Handle with users operations
  """

  alias Ecto.Changeset
  alias Banking.Accounts.{User, Account}
  alias Banking.Accounts.Account
  alias Banking.Users.Encryption
  alias Banking.Repo

  @doc """
  Create a new User with associated account

  ## Examples

      iex> register(%{field: value})
      {:ok, %User{}}

      iex> register(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  """
  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Changeset.cast_assoc(:account, with: &Account.changeset/2)
    |> hash_password()
    |> Changeset.put_assoc(:account, %Account{})
    |> Repo.insert()
  end

  @doc """
  Find an user and check if the password is correct
  """
  def find_user_and_check_password(%{"email" => email, "password" => password}) do
    Repo.get_by(User, email: String.downcase(email))
    |> check_password(password)
  end

  defp hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        Changeset.put_change(changeset, :password, Encryption.put_pass_hash(pass).password)

      _ ->
        changeset
    end
  end

  defp check_password(user, _password) when is_nil(user), do: {:error, :user_not_found}

  defp check_password(user, password), do: user |> Encryption.verify_password(password)
end
