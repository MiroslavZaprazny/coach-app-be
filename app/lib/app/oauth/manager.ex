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
    :crypto.strong_rand_bytes(32)
    |> Base.url_encode64(padding: false)
  end

  def get_auth_url(provider, state) do
    with {:ok, provider} <- get_provider(provider) do 
      client = provider.get_client()
      auth_url = provider.authorize_url(client, state: state)

      {:ok, auth_url}
    end
  end
end
