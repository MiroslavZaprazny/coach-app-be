defmodule AppWeb.OAuthController do
  use AppWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias App.OAuth.Manager

  alias AppWeb.Schemas.OAuth.{
    SupportedProvidersListResponseSchema,
    AuthUrlResponseSchema,
    AuthRequestBodySchema
  }

  alias AppWeb.Schemas.User.UserResponseSchema

  alias App.{Accounts, Session}

  tags(["OAuth"])

  operation(:providers,
    summary: "Supported OAuth providers",
    description: "Returns a list of supported OAuth providers",
    responses: [
      ok: {"Response", "application/json", SupportedProvidersListResponseSchema}
    ]
  )

  def providers(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{providers: Manager.supported_providers()})
  end

  tags(["OAuth"])

  operation(:auth,
    summary: "Authenticate a user based on a OAuth auth code",
    description: "Tries to authenticate a user based on the provider OAuth auth code",
    parameters: [
      provider: [in: :path, description: "OAuth Provider", type: :string, example: "google"]
    ],
    request_body: {"User params", "application/json", AuthRequestBodySchema},
    responses: [
      ok: {"Response", "application/json", UserResponseSchema}
    ]
  )

  def auth(
        conn,
        %{
          "provider" => provider_name,
          "auth_code" => auth_code
        }
      ) do
    with {:ok, provider} <- Manager.get_provider(provider_name),
         {:ok, client} <- provider.get_client(),
         {:ok, client_with_access_token} <- Manager.fetch_access_token(client, auth_code),
         {:ok, info} <- provider.get_user_info(client_with_access_token),
         {:ok, user} <- Accounts.find_or_create_oauth_user(info) do
      session_id = Session.create(user)

      conn
      |> Session.add_to_cookie(session_id)
      |> json(%{user: user})
    else
      {:error, :unsupported_provider} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Unsupported provider", supported: Manager.supported_providers()})

      {:error, reason} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Auth failed", reason: inspect(reason)})
    end
  end

  tags(["OAuth"])

  operation(:auth_url,
    summary: "Generates auth url",
    description: "Generates an auth url for a given provider",
    responses: [
      ok: {"Response", "application/json", AuthUrlResponseSchema}
    ]
  )

  def auth_url(conn, %{"provider" => provider_name}) do
    with {:ok, provider} <- Manager.get_provider(provider_name),
         {:ok, state} <- Manager.generate_state_token(),
         {:ok, auth_url} <- Manager.get_auth_url(provider, state) do
      conn
      |> json(%{auth_url: auth_url})
    else
      {:error, :unsupported_provider} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{error: "Unsupported provider", supported: Manager.supported_providers()})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Failed to generate auth URL", reason: inspect(reason)})
    end
  end

  # Development endpoint for retrieving the code
  def callback(conn, %{"code" => code}) do
    conn
    |> json(%{code: code})
  end
end
