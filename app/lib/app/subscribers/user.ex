defmodule App.Subscribers.User do
  use GenServer

  @impl true
  def init(_) do
    App.Events.User.subscribe()

    {:ok, %{}}
  end

  @impl true
  def handle_info({:user_registration, user}, state) do
    user
    |> App.Workers.ConfirmationEmail.new()
    |> Oban.insert()

    {:no_reply, state}
  end
end
