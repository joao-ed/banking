defmodule Banking.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:username, :string)
      add(:password, :string)
      add(:email, :string)
      add(:balance, :integer)

      timestamps()
    end

    create(unique_index(:users, [:email]))
  end

  def down do
    drop table(:users)
  end
end
