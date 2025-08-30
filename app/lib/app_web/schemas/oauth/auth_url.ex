defmodule AppWeb.Schemas.OAuth.AuthUrl do
    alias OpenApiSpex.Schema
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "AuthUrl",
      type: :object,
      properties: %{
        auth_url: %Schema{type: :string, example: "google_auth_url"}
      },
      required: [:auth_url],
      example: %{auth_url: "google_auth_url"}
    })
end
