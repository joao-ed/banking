defmodule Banking.Auth do
  @moduledoc """
  The boundry for the Auth system
  """

  import Ecto.{Query, Changeset}, warn: false

  alias Banking.Repo
  alias Banking.User
  alias Banking.Encryption

  def find_user_and_check_password(%{"email" => email, "password" => password}) do
    user = Repo.get_by(User, email: String.downcase(email))
    IO.inspect(check_password(user, password))

    case check_password(user, password) do
      {:ok, user} -> {:ok, user}
      {:error, message} -> {:error, message}
      _ -> {:error, "Could not login. Check your credentials and try again"}
    end
  end

  def register(attrs \\ %{}) do
    # let's read about struct (a specialized way of map ?)
    %User{}
    |> User.changeset(attrs)
    |> hash_password
    |> Repo.insert()
  end

  defp check_password(user, password) do
    case user do
      nil -> false
      _ -> Encryption.verify_password(user, password)
    end
  end

  def hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Encryption.put_pass_hash(pass).password)

      _ ->
        changeset
    end
  end
end
