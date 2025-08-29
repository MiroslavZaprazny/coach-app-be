defmodule AppWeb.AuthController do
#   use AppWeb, :controller

#   alias App.Accounts
#   alias App.Accounts.User

#   action_fallback AppWeb.FallbackController

#   def show(conn, %{"id" => id}) do
#     user = Accounts.get_user!(id)
#     render(conn, :show, user: user)
#   end
end
