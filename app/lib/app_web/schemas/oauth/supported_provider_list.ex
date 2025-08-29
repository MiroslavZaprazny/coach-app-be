defmodule AppWeb.Schemas.Providers.SupportedProvidersList do
    alias OpenApiSpex.Schema
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "SupportedProviderList",
      type: :object,
      properties: %{
        providers: %Schema{type: :array, example: ["google"]}
      },
      required: [:providers],
      example: %{providers: ["google"]}
    })
end
