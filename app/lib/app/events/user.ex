defmodule App.Events.User do
  alias Pheonix.PubSub

  @topic "accounts"

  def subscribe() do
    PubSub.subscribe(App.PubSub, @topic)
  end

  def broadcast_user_registration(user) do
    PubSub.broadcast(App.PubSub, @topic, {:user_registration, user})
  end
end
