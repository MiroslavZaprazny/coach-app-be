defmodule AppWeb.Schemas.OAuth.SupportedProvidersList do
    alias OpenApiSpex.Schema
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "SupportedProviderList",
      type: :object,
      properties: %{
        providers: %Schema{type: :array, example: ["google"]}
      }
    })
end
