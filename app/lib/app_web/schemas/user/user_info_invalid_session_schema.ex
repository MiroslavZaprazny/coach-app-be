defmodule AppWeb.Schemas.User.UserInfoInvalidSessionSchema do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "UserInfoInvalidSessionSchema",
    type: :object,
    properties: %{
      error: %Schema{
        type: :string,
        example: "No session found"
      }
    }
  })
end
