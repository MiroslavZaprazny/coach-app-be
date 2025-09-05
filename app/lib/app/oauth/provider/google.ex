defmodule App.OAuth.Providers.Google do
  @behaviour App.OAuth.Provider
  def provider_name, do: "google"

  def get_client do
    {:ok, OAuth2.Client.new([
      strategy: OAuth2.Strategy.AuthCode,
      client_id: client_id(),
      client_secret: client_secret(),
      site: "https://accounts.google.com",
      authorize_url: "/o/oauth2/v2/auth",
      token_url: "/o/oauth2/token",
      redirect_uri: redirect_uri(),
      serializers: %{"application/json" => Jason}
    ])}
  end

  def authorize_url(client, opts \\ []) do
    default_opts = [
      scope: "openid email profile",
      access_type: "offline",
      prompt: "consent"
    ]
    
    OAuth2.Client.authorize_url!(client, Keyword.merge(default_opts, opts))
  end

  def get_user_info(client) do
    case OAuth2.Client.get(client, "https://www.googleapis.com/oauth2/v2/userinfo") do
      {:ok, %OAuth2.Response{status_code: 200, body: user_data}} ->
        {:ok, %{
          email: user_data["email"],
          name: user_data["name"],
          oauth_id: user_data["id"],
          oauth_provider: :google,
          avatar_url: user_data["picture"]
        }}
      
      {:error, %OAuth2.Error{} = error} ->
        {:error, error}

      {:ok, %OAuth2.Response{status_code: status_code, body: %{"error" => error, "error_description" => description}}} ->
        {:error, "Google returned (#{status_code}) with error: #{error} - #{description}"}
      
      {:error, %OAuth2.Response{} = response} ->
        {:error, response}
    end
  end

  defp client_id, do: Application.get_env(:app, :google)[:client_id]
  defp client_secret, do: Application.get_env(:app, :google)[:client_secret]
  defp redirect_uri, do: Application.get_env(:app, :google)[:redirect_uri]
end
