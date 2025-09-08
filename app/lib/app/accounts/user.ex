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
    field :password, :string, virtual: true
    field :password_confirmation, :string, virtual: true
    field :password_hash, :string

    timestamps(type: :utc_datetime)
  end

  def oauth_changeset(user, attrs) do
    user
    |> cast(attrs, [:email, :name, :oauth_provider, :oauth_id, :registration_status, :avatar_url])
    |> validate_required([
      :email,
      :name,
      :registration_status,
      :oauth_provider,
      :oauth_id,
      :avatar_url
    ])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/, message: "must be a valid email")
    |> unique_constraint(:email)
  end

  def registration_changeset(user, attrs) do
    try do
      user
      |> cast(attrs, [:email, :password, :password_confirmation, :registration_status])
      |> validate_required([
        :email,
        :registration_status,
        :password,
        :password_confirmation
      ])
      |> validate_format(:email, ~r/^[^\s]+@[^\s]+\.[^\s]+$/, message: "must be a valid email")
      |> validate_length(:password, min: 8, max: 128)
      |> validate_confirmation(:password, message: "passwords do not match")
      |> unique_constraint(:email)
      |> hash_password()
    rescue
      e in Ecto.CastError ->
        IO.inspect(e)
    end
  end

  defp hash_password(%Ecto.Changeset{valid?: true, changes: %{password: password}} = changeset) do
    change(changeset, password_hash: Bcrypt.hash_pwd_salt(password))
  end

  defp hash_password(changeset), do: changeset

  def verify_password(user, password) do
    Bcrypt.verify_pass(password, user.password_hash)
  end
end
