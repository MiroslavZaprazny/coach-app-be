defmodule AppWeb.Schemas.Auth.RegisterResponseSchema do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "RegisterResponseSchema",
    type: :object,
    properties: %{
      email: %Schema{type: :string, example: "myemail@email.com"},
      registration_status: %Schema{
        type: :string,
        enum: ["incomplete", "complete"],
        example: "incomplete"
      }
    }
  })
end
