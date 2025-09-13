defmodule AppWeb.AuthControllerTest do
  use AppWeb.ConnCase
  alias App.Accounts

  describe "register" do
    test "happy path", %{conn: conn} do
      email = "myemail@gmail.com"

      conn =
        post(
          conn,
          ~p"/api/auth/register",
          %{email: email, password: "mypassword123", password_confirmation: "mypassword123"}
        )

      assert json_response(conn, 200)

      user = Accounts.get_by_email(email)
      assert user.registration_status == :incomplete
      assert user.oauth_id == nil
      assert user.oauth_provider == nil
    end
  end
end
