defmodule AppWeb.Schemas.Auth.RegisterRequestBodySchema do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "RegisterRequestBodySchema",
    type: :object,
    properties: %{
      email: %Schema{type: :string, example: "myemail@email.com"},
      password: %Schema{type: :string, example: "password123"},
      password_confirmation: %Schema{type: :string, example: "password123"}
    }
  })
end
