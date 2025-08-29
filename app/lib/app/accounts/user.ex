defmodule App.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :email, :string
    field :role, :string
    field :first_name, :string
    field :last_name, :string
    field :phone, :string
    field :oauth_provider, :string
    field :oauth_id, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :role, :first_name, :last_name, :phone, :oauth_provider, :oauth_id])
    |> validate_required([:email, :role, :first_name, :last_name, :phone, :oauth_provider, :oauth_id])
    |> unique_constraint(:email)
  end
end
