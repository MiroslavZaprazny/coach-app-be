defmodule AppWeb.Schemas.User.UserSessionNotFound do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "UserSessionNotFound",
    type: :object,
    properties: %{
      error: %Schema{
        type: :string,
        example: "No session found"
      }
    }
  })
end
