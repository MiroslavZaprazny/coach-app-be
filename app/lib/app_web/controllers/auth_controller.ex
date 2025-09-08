defmodule AppWeb.AuthController do
  use AppWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias App.{Accounts, Session}
  alias AppWeb.Schemas.Auth.{RegisterRequestBodySchema, LoginRequestBodySchema}
  alias AppWeb.Schemas.User.UserResponseSchema
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
    IO.inspect(params)

    case Accounts.register(params) do
      {:ok, user} ->
        Session.create(user)
        |> Session.add_to_cookie(conn)

        conn
        |> json(%{
          user: %{
            registration_status: user.registration_status,
            email: user.email
          }
        })
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
          true ->
            Session.create(user)
            |> Session.add_to_cookie(conn)

            conn
            |> json(%{
              user: %{
                registration_status: user.registration_status,
                email: user.email
              }
            })

          false ->
            conn
            |> put_status(:unprocessable_entity)
            |> json(%{error: "Invalid credentials"})
        end
    end
  end
end
