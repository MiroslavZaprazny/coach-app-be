defmodule AppWeb.AuthController do
  use AppWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias OpenApiSpex.Schema
  require OpenApiSpex
  alias App.{Accounts, Session}
  alias AppWeb.Schemas.Auth.{RegisterRequestBodySchema, LoginRequestBodySchema}
  alias AppWeb.Schemas.User.{UserResponseSchema, UserSessionNotFound}
  alias App.Accounts.User

  tags(["Auth"])

  operation(:register,
    summary: "Register",
    description: "Registers a user, if the operation is successful we log him in",
    request_body: {"Req params", "application/json", RegisterRequestBodySchema},
    responses: [
      ok: {"Response", "application/json", UserResponseSchema}
    ]
  )

  def register(
        conn,
        %{
          "email" => _email,
          "password" => _password,
          "password_confirmation" => _password_confirmation
        } = params
      ) do
    case Accounts.register(params) do
      {:ok, user} ->
        case Session.create(conn, user) do
          {:ok, conn} ->
            conn
            |> json(%{user: user})

          {:error, _reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Internal server error"})
        end

      {:error, %Ecto.Changeset{} = changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> put_view(json: AppWeb.ChangesetJSON)
        |> render(:error, changeset: changeset)
    end
  end

  operation(:login,
    summary: "Login",
    description: "Login",
    request_body: {"Req params", "application/json", LoginRequestBodySchema},
    responses: [
      ok: {"Response", "application/json", UserResponseSchema}
    ]
  )

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_by_email(email) do
      nil ->
        Bcrypt.no_user_verify()

        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Invalid credentials"})

      user ->
        case User.verify_password(user, password) do
          false ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Invalid credentials"})

          true ->
            case Session.create(conn, user) do
              {:ok, conn} ->
                conn
                |> json(%{user: user})

              {:error, _reason} ->
                conn
                |> put_status(:internal_server_error)
                |> json(%{error: "Internal server error"})
            end
        end
    end
  end

  operation(:user_info,
    summary: "Auth user info",
    description: "Retrieves user info based on the session",
    responses: [
      ok: {"Response", "application/json", UserResponseSchema},
      unprocessable_entity: {"Response", "application/json", UserSessionNotFound}
    ]
  )

  def user_info(conn, _params) do
    session_id =
      conn
      |> get_session(:user_session_id)

    case session_id do
      nil ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "No session found"})

      session_id ->
        case Session.get(session_id) do
          {:ok, data} ->
            conn
            |> json(%{user: data})

          {:error, :not_found} ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "No session found"})
        end
    end
  end

  operation(:logout,
    summary: "Logout",
    description: "Destroy user session",
    responses: [
      unprocessable_entity: {"Response", "application/json", UserSessionNotFound}
    ]
  )

  def logout(conn, _params) do
    session_id =
      conn
      |> get_session(:user_session_id)

    case session_id do
      nil ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "No session found"})

      session_id ->
        case Session.destroy(conn, session_id) do
          {:ok, conn} ->
            conn
            |> json(%{status: "ok"})

          {:error, _reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Internal server error"})
        end
    end
  end
end
