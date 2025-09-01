defmodule App.OAuth.Manager do
  alias App.OAuth.Providers

  @providers %{
    "google" => Providers.Google,
  }

  def supported_providers, do: Map.keys(@providers)

  def get_provider(provider_name) when is_map_key(@providers, provider_name) do
    {:ok, @providers[provider_name]}
  end
  def get_provider(_), do: {:error, :unsupported_provider}

  def generate_state_token do
    {:ok, :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)}
  end

  def get_auth_url(provider, state) do
    {:ok, client} = provider.get_client()
    auth_url = provider.authorize_url(client, state: state)

    {:ok, auth_url}
  end

  #Access token is saved to the OAuth2.Client instance
  def fetch_access_token(client, code) do
    IO.inspect(client, label: "Client before code exchange")

    case OAuth2.Client.get_token(client, code: code) do
      {:ok, %OAuth2.Client{} = updated_client} ->
        {:ok, updated_client}
      
      {:ok, %OAuth2.Client{token: nil}} ->
        {:error, :no_token_received}
      
      {:error, %OAuth2.Error{} = error} ->
        {:error, error}
      
      {:error, %OAuth2.Response{} = response} ->
        {:error, response}
    end
  end
end
