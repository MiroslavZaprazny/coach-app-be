defmodule App.Session do
  alias App.Cache

  @session_ttl 2_592_000

  def create(user) do
    session_id = :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)
    serialized_user = :erlang.term_to_binary(user)

    case Cache.set(session_id, serialized_user, @session_ttl) do
      {:ok, _result} ->
        {:ok, session_id}

      {:error, error} ->
        {:error, error}
    end
  end

  def add_to_cookie(conn, session_id) do
    conn
    |> Plug.Conn.put_session(:user_session_id, session_id)
  end

  def get(session_id) do
    case Cache.get(session_id) do
      {:ok, nil} ->
        {:error, :not_found}

      {:ok, binary_data} ->
        {:ok, :erlang.binary_to_term(binary_data)}
    end
  end

  def session_ttl, do: @session_ttl
end
