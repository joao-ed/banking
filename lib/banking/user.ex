defmodule Banking.User do
  @moduledoc """
  The user model.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(email password username balance)a

  schema "users" do
    field(:email, :string, unique: true)
    field(:password, :string)
    field(:username, :string, unique: true)
    field(:balance, :integer, default: 100_000)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 8)
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/)
    |> unique_constraint(:email)
  end
end
