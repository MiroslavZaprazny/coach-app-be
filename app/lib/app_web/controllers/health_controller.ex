defmodule AppWeb.HealthController do
  use AppWeb, :controller
  use OpenApiSpex.ControllerSpecs

  alias OpenApiSpex.Schema

  operation :check,
    summary: "Health check",
    description: "Returns health status of the api",
    responses: %{
      200 => {
        "Health check successful",
        "application/json",
        %Schema{
          type: :object,
          properties: %{
            status: %Schema{type: :string, example: "ok"}
          },
          example: %{status: "ok"}
        }
      }
    }
  def check(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{status: "ok"})
  end
end
