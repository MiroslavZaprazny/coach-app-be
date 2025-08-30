defmodule AppWeb.OAuthController do
  use AppWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias App.OAuth.Manager
  alias AppWeb.Schemas.OAuth.{SupportedProvidersList, AuthUrl}
  alias App.{Accounts, Session}

  tags ["OAuth"]
  operation :providers,
    summary: "Supported OAuth providers",
    description: "Returns a list of supported OAuth providers",
    responses: [
      ok: {"Response", "application/json", SupportedProvidersList}
    ]
  def providers(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{providers: Manager.supported_providers()})
  end

  tags ["OAuth"]
  operation :auth,
    summary: "Authenticate a user based on a OAuth auth code",
    description: "Tries to authenticate a user based on a OAuth auth code. If the user is already registered we log him in, otherwise he has to finish registration",
    responses: [
      #TODO: ok: {"Response", "application/json", SupportedProvidersList}
    ]
  def auth(
      conn, 
      %{
        "provider" => provider_name,
        "auth_code" => auth_code
      }
  )  do
    with {:ok, provider} <- Manager.get_provider(provider_name),
         {:ok, token} <- Manager.exchange_code_for_access_token(provider, auth_code),
         {:ok, info} <- provider.get_user_info(provider, token),
         {:ok, user} <- Accounts.find_or_create_user(info) do
          case user.registration_status do
           :complete ->
              Session.create(user)
              |> Session.add_to_cookie(conn)
          end
            conn
              |> json(%{user: %{
                    registration_status: user.registration_status,
                    email: user.email,
                    name: user.name,
                    avatar_url: user.avatar_url,
                 }})
    else
      {:error, :unsupported_provider} ->
        conn 
        |> put_status(:bad_request)
        |> json(%{error: "Unsupported provider", supported: Manager.supported_providers()})

      {:error, reason} ->
        conn 
        |> put_status(:bad_request)
        |> json(%{error: "Auth failed", reason: inspect(reason)})
    end
  end

  tags ["OAuth"]
  operation :auth_url,
    summary: "Generates auth url",
    description: "Generates an auth url for a given provider",
    responses: [
      ok: {"Response", "application/json", AuthUrl}
    ]
  def auth_url(conn, %{"provider" => provider_name}) do
    with {:ok, provider} <- Manager.get_provider(provider_name),
         {:ok, token} <- Manager.generate_state_token(),
         {:ok, auth_url} <- Manager.get_auth_url(provider, token) do
            conn
            |> json(%{auth_url: auth_url})
    else
      {:error, :unsupported_provider} ->
        conn 
        |> put_status(:bad_request)
        |> json(%{error: "Unsupported provider", supported: Manager.supported_providers()})
      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: "Failed to generate auth URL", reason: inspect(reason)})
    end
  end

  #Development endpoint for retrieving the code
  def callback(conn, %{"code" => code}) do
    conn
      |> json(%{code: code})
  end
end
