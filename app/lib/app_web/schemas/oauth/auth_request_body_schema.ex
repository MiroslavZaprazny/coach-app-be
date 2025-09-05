defmodule AppWeb.Schemas.OAuth.AuthRequestBodySchema do
    alias OpenApiSpex.Schema
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "AuthRequestBodySchema",
      type: :object,
      properties: %{
        auth_code: %Schema{type: :string, example: "auth_code_from_google"},
      }
    })
end
