defmodule AppWeb.AuthController do
  use AppWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias App.{Accounts, Session}
  alias AppWeb.Schemas.Auth.{RegisterRequestBodySchema, RegisterResponseSchema}

  tags(["Auth"])

  operation(:register,
    summary: "Register",
    description: "Registers a user, if the operation is successful we log him in",
    request_body: {"Req params", "application/json", RegisterRequestBodySchema},
    responses: [
      ok: {"Response", "application/json", RegisterResponseSchema}
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
end
