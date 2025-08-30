defmodule AppWeb.UserControllerTest do
  use AppWeb.ConnCase

  import App.AccountsFixtures
  alias App.Accounts.User

  @create_attrs %{
    role: "some role",
    email: "some email",
    first_name: "some first_name",
    last_name: "some last_name",
    phone: "some phone",
    oauth_provider: "some oauth_provider",
    oauth_id: "some oauth_id"
  }
  @update_attrs %{
    role: "some updated role",
    email: "some updated email",
    first_name: "some updated first_name",
    last_name: "some updated last_name",
    phone: "some updated phone",
    oauth_provider: "some updated oauth_provider",
    oauth_id: "some updated oauth_id"
  }
  @invalid_attrs %{role: nil, email: nil, first_name: nil, last_name: nil, phone: nil, oauth_provider: nil, oauth_id: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, ~p"/api/users")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some email",
               "first_name" => "some first_name",
               "last_name" => "some last_name",
               "oauth_id" => "some oauth_id",
               "oauth_provider" => "some oauth_provider",
               "phone" => "some phone",
               "role" => "some role"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/users", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/users/#{id}")

      assert %{
               "id" => ^id,
               "email" => "some updated email",
               "first_name" => "some updated first_name",
               "last_name" => "some updated last_name",
               "oauth_id" => "some updated oauth_id",
               "oauth_provider" => "some updated oauth_provider",
               "phone" => "some updated phone",
               "role" => "some updated role"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, ~p"/api/users/#{user}", user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, ~p"/api/users/#{user}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/users/#{user}")
      end
    end
  end

  defp create_user(_) do
    user = user_fixture()

    %{user: user}
  end
end
