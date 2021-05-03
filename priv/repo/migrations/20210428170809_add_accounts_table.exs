defmodule Banking.Repo.Migrations.AddAccountsTable do
  use Ecto.Migration

  def up do
    create table(:accounts) do
      add :balance, :integer, null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false
      timestamps()
    end

    create(index(:accounts, [:user_id]))
  end

  def down do
    drop(table(:accounts))
  end
end
