defmodule App.AccountsTest do
  use App.DataCase

  alias App.Accounts

  describe "users" do
    alias App.Models.User

    test "register user" do
      data = %{
        "email" => "ewqjeiowq@gmail.com",
        "password" => "mypassword123",
        "password_confirmation" => "mypassword123"
      }

      assert {:ok, %User{} = user} = Accounts.register(data)
      assert user.email == data["email"]
      assert user.oauth_provider == nil
      assert user.oauth_id == nil
      assert user.name == nil
      assert user.avatar_url == nil
    end

    test "create oauth user" do
      data = %{
        name: "John Doe",
        email: "swqjeiowq@gmail.com",
        avatar_url: "https://localhost:4000/profile.jpg",
        oauth_provider: "google",
        oauth_id: "321321321"
      }

      assert {:ok, %User{} = user} = Accounts.find_or_create_oauth_user(data)
      assert user.email == data.email
      assert user.oauth_provider != nil
      assert user.oauth_id != nil
      assert user.name != nil
      assert user.avatar_url != nil
    end
  end
end
