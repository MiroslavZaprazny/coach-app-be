defmodule App.Session do
  alias App.Cache

  @session_ttl 2592000

  def create(user) do
    session_id = :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)
    serialized_user = :erlang.term_to_binary(user)
    Cache.set(session_id, serialized_user, @session_ttl)

    session_id
  end

  def add_to_cookie(session_id, conn) do
    conn
      |> Plug.Conn.put_session(:session_id, session_id)
  end

  def session_ttl, do: @session_ttl
end
