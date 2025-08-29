defmodule AppWeb.HealthController do
  use AppWeb, :controller
  use OpenApiSpex.ControllerSpecs

  tags ["health"]
  operation :check,
    summary: "Health check",
    responses: [
      ok: {"Response", "application/json", %{status: "ok"}}
    ]
  def check(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(%{status: "ok"})
  end
end
