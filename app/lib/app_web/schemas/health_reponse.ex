defmodule AppWeb.Schemas.HealthResponse do
  alias OpenApiSpex.Schema
  require OpenApiSpex

  OpenApiSpex.schema(%{
    title: "HealthResponse",
    type: :object,
    properties: %{
      status: %Schema{type: :string, example: "ok"}
    }
  })
end
