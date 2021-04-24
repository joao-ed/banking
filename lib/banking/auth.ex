defmodule Banking.Auth do
  @moduledoc """
  The boundry for the Auth system
  """
  import Ecto.{Query, Changeset}, warn: false

  alias Banking.Repo
  alias Banking.User
  alias Banking.Encryption

  def register(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> hash_password
    |> Repo.insert()
  end

  def hash_password(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password, Encryption.put_pass_hash(pass).password_hash)

      _ ->
        changeset
    end
  end
end
