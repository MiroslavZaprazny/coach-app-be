defmodule AppWeb.Schemas.OAuth.SupportedProvidersListResponseSchema do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "SupportedProviderListResponse",
    type: :object,
    properties: %{
      providers: %Schema{type: :array, example: ["google"]}
    }
  })
end
