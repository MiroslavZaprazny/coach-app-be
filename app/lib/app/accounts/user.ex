defmodule App.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Ecto.Enum

  schema "users" do
    field :oauth_id, :string
    field :oauth_provider, Enum, values: [:google]
    field :name, :string
    field :avatar_url, :string
    field :email, :string
    field :registration_status, Enum, values: [:complete, :incomplete]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :oauth_provider, :oauth_id, :registration_status, :avatar_url])
    |> validate_required([
      :email,
      :name,
      :oauth_provider,
      :oauth_id,
      :registration_status,
      :avatar_url
    ])
    |> unique_constraint(:oauth_id)
  end
end
