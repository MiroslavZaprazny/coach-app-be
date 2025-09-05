defmodule AppWeb.HealthController do
  use AppWeb, :controller
  use OpenApiSpex.ControllerSpecs
  alias AppWeb.Schemas.HealthResponse

  tags(["Health"])

  operation(:check,
    summary: "Health check",
    description: "Returns health status of the api",
    responses: [
      ok: {"Response", "application/json", HealthResponse}
    ]
  )

  def check(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{status: "ok"})
  end
end
