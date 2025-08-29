defmodule App.ApiSpec do
  alias OpenApiSpex.{Info, OpenApi, Paths, Server}
  alias AppWeb.{Endpoint, Router}

  @behaviour OpenApi

  @impl OpenApi
  def spec do
      %OpenApi{
        servers: [Server.from_endpoint(Endpoint)],
        info: %Info {
          title: "Coach app API",
          version: "1.0",
        },
        paths: Paths.from_router(Router)
      }
      |> OpenApiSpex.resolve_schema_modules()
  end
end
