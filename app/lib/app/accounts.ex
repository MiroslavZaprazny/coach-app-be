defmodule App.Accounts do
  import Ecto.Query, warn: false
  alias App.Repo

  alias App.Accounts.User

  defp create_oauth_user(attrs) do
    %User{}
    |> User.oauth_changeset(Map.put(attrs, :registration_status, :incomplete))
    |> Repo.insert()
  end

  def find_or_create_oauth_user(attrs) do
    case Repo.get_by(User, email: Map.get(attrs, :email)) do
      nil ->
        create_oauth_user(attrs)

      user ->
        {:ok, user}
    end
  end

  def register(attrs) do
    %User{}
    |> User.registration_changeset(Map.put(attrs, "registration_status", :incomplete))
    |> Repo.insert()
  end
end
