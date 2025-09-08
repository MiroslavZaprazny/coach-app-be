defmodule AppWeb.Schemas.Auth.LoginRequestBodySchema do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "LoginRequestBodySchema",
    type: :object,
    properties: %{
      email: %Schema{type: :string, example: "myemail@email.com"},
      password: %Schema{type: :string, example: "password123"}
    }
  })
end
