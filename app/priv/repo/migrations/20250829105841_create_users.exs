defmodule App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :role, :string
      add :first_name, :string
      add :last_name, :string
      add :phone, :string
      add :oauth_provider, :string
      add :oauth_id, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:email])
  end
end
