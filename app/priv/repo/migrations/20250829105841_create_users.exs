defmodule App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string, null: false
      add :name, :string, null: false
      add :avatar_url, :string, null: false
      add :oauth_provider, :string, null: false
      add :oauth_id, :string, null: false
      add :registration_status, :string, null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:oauth_id])
  end
end
