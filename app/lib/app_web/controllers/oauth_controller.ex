defmodule AppWeb.OAuthController do
  use AppWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias App.OAuth.Manager
  alias AppWeb.Schemas.Providers.SupportedProvidersList

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

  def auth_url(conn, %{"provider" => provider}) do
    case Manager.get_provider(provider) do
      {:ok, _provider_module} ->
        token = Manager.generate_state_token()

        #todo instead of putting it in a session we should just put the token in redis
        case Manager.get_auth_url(provider, token) do
          {:ok, url} ->
            conn
            |> put_session(:oauth_state_token, token)
            |> json(%{auth_url: url})
          {:error, reason} ->
            conn
            |> put_status(:internal_server_error)
            |> json(%{error: "Failed to generate auth URL", reason: inspect(reason)})
        end

      {:error, :unsupported_provider} ->
        conn 
        |> put_status(:bad_request)
        |> json(%{error: "Unsupported provider", supported: Manager.supported_providers()})
    end
  end
end
