defmodule App.AccountsTest do
  use App.DataCase

  alias App.Accounts

  describe "users" do
    alias App.Accounts.User

    import App.AccountsFixtures

    @invalid_attrs %{
      role: nil,
      email: nil,
      first_name: nil,
      last_name: nil,
      phone: nil,
      oauth_provider: nil,
      oauth_id: nil
    }

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      valid_attrs = %{
        role: "some role",
        email: "some email",
        first_name: "some first_name",
        last_name: "some last_name",
        phone: "some phone",
        oauth_provider: "some oauth_provider",
        oauth_id: "some oauth_id"
      }

      assert {:ok, %User{} = user} = Accounts.create_user(valid_attrs)
      assert user.role == "some role"
      assert user.email == "some email"
      assert user.first_name == "some first_name"
      assert user.last_name == "some last_name"
      assert user.phone == "some phone"
      assert user.oauth_provider == "some oauth_provider"
      assert user.oauth_id == "some oauth_id"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()

      update_attrs = %{
        role: "some updated role",
        email: "some updated email",
        first_name: "some updated first_name",
        last_name: "some updated last_name",
        phone: "some updated phone",
        oauth_provider: "some updated oauth_provider",
        oauth_id: "some updated oauth_id"
      }

      assert {:ok, %User{} = user} = Accounts.update_user(user, update_attrs)
      assert user.role == "some updated role"
      assert user.email == "some updated email"
      assert user.first_name == "some updated first_name"
      assert user.last_name == "some updated last_name"
      assert user.phone == "some updated phone"
      assert user.oauth_provider == "some updated oauth_provider"
      assert user.oauth_id == "some updated oauth_id"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end
  end
end
