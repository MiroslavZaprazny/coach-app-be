defmodule App.OAuth.Provider do
  @type user_info :: %{
    email: String.t(),
    name: String.t(),
    provider_id: String.t(),
    avatar_url: String.t() | nil
  }

  @callback get_client() :: {:ok, OAuth2.Client.t()}
  @callback get_user_info(OAuth2.AccessToken.t()) :: {:ok, user_info()} | {:error, term()}
  @callback provider_name() :: String.t()
  @callback authorize_url(OAuth2.Client.t(), list()) :: String.t()
end
