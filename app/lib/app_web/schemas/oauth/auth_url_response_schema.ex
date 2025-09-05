defmodule AppWeb.Schemas.OAuth.AuthUrlResponseSchema do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "AuthUrlResponse",
    type: :object,
    properties: %{
      auth_url: %Schema{type: :string, example: "google_auth_url"}
    }
  })
end
