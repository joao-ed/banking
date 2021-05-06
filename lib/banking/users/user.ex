defmodule Banking.Users.User do
  @moduledoc """
  The User model.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Banking.Accounts.Account

  @required_fields ~w(email password username)a

  schema "users" do
    field :email, :string, unique: true
    field :password, :string, virtual: true
    field :password_hash, :string
    field :username, :string

    has_one :account, Account

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 8)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
  end
end
