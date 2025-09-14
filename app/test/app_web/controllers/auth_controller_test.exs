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
      assert get_session(conn, :user_session_id) != nil

      user = Accounts.get_by_email(email)
      assert user.registration_status == :incomplete
      assert user.oauth_id == nil
      assert user.oauth_provider == nil
    end

    test "invalid email", %{conn: conn} do
      email = "jioejqwio.com"

      conn =
        post(
          conn,
          ~p"/api/auth/register",
          %{email: email, password: "mypassword123", password_confirmation: "mypassword123"}
        )

      assert json_response(conn, 422)
    end

    test "invalid password", %{conn: conn} do
      email = "myemail@gmail.com"

      conn =
        post(
          conn,
          ~p"/api/auth/register",
          %{email: email, password: "123", password_confirmation: "123"}
        )

      assert json_response(conn, 422)
    end

    test "passwords do not match", %{conn: conn} do
      email = "myemail@gmail.com"

      conn =
        post(
          conn,
          ~p"/api/auth/register",
          %{
            email: email,
            password: "213password$123",
            password_confirmation: "12421321password412"
          }
        )

      assert json_response(conn, 422)
    end

    test "email already registered", %{conn: conn} do
      user = App.AccountsFixtures.user_fixture()

      conn =
        post(
          conn,
          ~p"/api/auth/register",
          %{email: user.email, password: "mypassword123", password_confirmation: "mypassword123"}
        )

      assert json_response(conn, 422)
    end
  end

  describe "login" do
    test "happy path", %{conn: conn} do
      user = App.AccountsFixtures.user_fixture()

      conn =
        post(
          conn,
          ~p"/api/auth/login",
          %{email: user.email, password: "mypassword123"}
        )

      assert json_response(conn, 200)
      assert get_session(conn, :user_session_id) != nil
    end

    test "invalid email", %{conn: conn} do
      user = App.AccountsFixtures.user_fixture()

      conn =
        post(
          conn,
          ~p"/api/auth/login",
          %{email: "#{user.email}123", password: "mypassword123"}
        )

      assert json_response(conn, 422)
      assert get_session(conn, :user_session_id) == nil
    end

    test "invalid password", %{conn: conn} do
      user = App.AccountsFixtures.user_fixture()

      conn =
        post(
          conn,
          ~p"/api/auth/login",
          %{email: user.email, password: "testerino123"}
        )

      assert json_response(conn, 422)
      assert get_session(conn, :user_session_id) == nil
    end
  end

  describe "user info" do
    test "happy path after registration", %{conn: conn} do
      email = "myemail@gmail.com"

      conn =
        post(
          conn,
          ~p"/api/auth/register",
          %{email: email, password: "mypassword123", password_confirmation: "mypassword123"}
        )

      assert json_response(conn, 200)
      assert get_session(conn, :user_session_id) != nil

      conn = get(conn, ~p"/api/auth/user-info")
      assert json_response(conn, 200)

      assert %{
               "avatar_url" => avatar_url,
               "email" => email,
               "id" => id,
               "name" => name,
               "registration_status" => registration_status
             } = json_response(conn, 200)["user"]

      assert avatar_url == nil
      assert name == nil
      assert email == email
      assert id != nil
      assert registration_status == "incomplete"
    end

    test "session cookie not sent in request", %{conn: conn} do
      conn = get(conn, ~p"/api/auth/user-info")
      assert json_response(conn, 422)
    end
  end

  describe "logout" do
    test "happy path", %{conn: conn} do
      user = App.AccountsFixtures.user_fixture()

      conn =
        post(
          conn,
          ~p"/api/auth/login",
          %{email: user.email, password: "mypassword123"}
        )

      assert json_response(conn, 200)
      assert get_session(conn, :user_session_id) != nil

      conn = post(conn, ~p"/api/auth/logout")

      assert json_response(conn, 200)
      assert get_session(conn, :user_session_id) == nil
    end
  end
end
