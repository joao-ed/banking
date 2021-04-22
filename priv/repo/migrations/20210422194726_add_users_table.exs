defmodule Banking.Repo.Migrations.AddUsersTable do
  use Ecto.Migration

  def up do
    create table(:users) do
      add(:username, :string)
      add(:password, :string)
      add(:email, :string)
      add(:balance, :float)
      
      timestamps(inserted_at: :created_at)
    end

    create(unique_index(:users, [:email]))
  end

  def down do
    drop table(:users)
  end

end
