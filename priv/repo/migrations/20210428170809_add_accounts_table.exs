defmodule Banking.Repo.Migrations.AddAccountsTable do
  use Ecto.Migration

  def change do
    create table(:accounts) do
      add :balance, :integer, null: false
      add :user_id, references(:users), null: false
      timestamps()
    end

    create index :accounts, [:user_id]
  end
end
