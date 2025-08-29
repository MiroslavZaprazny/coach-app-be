defmodule AppWeb.HealthController do
  use AppWeb, :controller
  use OpenApiSpex.ControllerSpecs

  operation :check,
    summary: "Health check",
    description: "Returns health status of the api",
    responses: %{
      200 => {
        "Health check successful",
        "application/json",
        %{
          type: :object,
          properties: %{
            status: %{type: :string, example: "ok"}
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
