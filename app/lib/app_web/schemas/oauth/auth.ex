defmodule AppWeb.Schemas.OAuth.Auth do
    alias OpenApiSpex.Schema
    require OpenApiSpex

    OpenApiSpex.schema(%{
      title: "Auth",
      type: :object,
      properties: %{
        name: %Schema{type: :string, example: "John Doe"},
        email: %Schema{type: :string, example: "john.doe@email.com"},
        avatar_url: %Schema{type: :string, example: "https://jondoepicture.com"},
        registration_status: %Schema{type: :string, enum: ["incomplete", "complete"], example: "incomplete"},
      },
    })
end
