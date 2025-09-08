defmodule App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string, null: true
      add :avatar_url, :string, null: true
      add :oauth_provider, :string, null: true
      add :oauth_id, :string, null: true
      add :registration_status, :string, null: false
      add :password_hash, :string, null: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:oauth_id, :email])
  end
end
