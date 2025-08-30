defmodule App.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :email, :string
      add :name, :string
      add :avatar_url, :string
      add :oauth_provider, :oauth_provider_enum
      add :oauth_id, :string
      add :registration_status, :registration_status_enum

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:oauth_id])
  end
end
