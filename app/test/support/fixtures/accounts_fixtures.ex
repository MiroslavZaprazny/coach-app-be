defmodule App.AccountsFixtures do
  def user_fixture() do
    {:ok, user} =
      App.Accounts.register(%{
        "email" => "myemail@gmail.com",
        "password" => "mypassword123",
        "password_confirmation" => "mypassword123"
      })

    user
  end
end
