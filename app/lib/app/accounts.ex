defmodule App.Accounts do
  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Accounts.User

  @type oauth_attrs :: %{
          name: String.t(),
          email: String.t(),
          oauth_provider: String.t(),
          oauth_id: String.t(),
          avatar_url: String.t()
        }

  @spec create_oauth_user(oauth_attrs()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  defp create_oauth_user(attrs) do
    %User{}
    |> User.oauth_changeset(Map.put(attrs, :registration_status, :incomplete))
    |> Repo.insert()
  end

  @spec find_or_create_oauth_user(oauth_attrs()) :: {:ok, User.t()} | {:error, Ecto.Changeset.t()}
  def find_or_create_oauth_user(attrs) do
    case Repo.get_by(User, email: Map.get(attrs, :email)) do
      nil ->
        create_oauth_user(attrs)

      user ->
        {:ok, user}
    end
  end

  @spec register(%{
          email: String.t(),
          password: String.t(),
          password_confirmation: String.t()
        }) :: {:ok, %User{}} | {:error, Ecto.Changeset.t()}
  def register(attrs) do
    %User{}
    |> User.registration_changeset(Map.put(attrs, "registration_status", :incomplete))
    |> Repo.insert()
  end

  @spec get_by_email(String.t()) :: nil | User.t()
  def get_by_email(email) do
    Repo.get_by(User, email: email)
  end
end
