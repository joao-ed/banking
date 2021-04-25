defmodule Banking.User do
  @moduledoc """
  The user model.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(email username password balance)a

  schema "users" do
    field(:email, :string, unique: true)
    field(:password, :string)
    field(:username, :string, unique: true)
    field(:balance, :float, default: 1.000)

    # has_many(:transfer, Banking.Transfer)

    timestamps(inserted_at: :created_at)
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_length(:password, min: 8)
    # A rudmentary email validation. improve it!
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end
end
