defmodule App.Session do
  alias App.Cache

  @session_ttl 2_592_000

  @spec create(Plug.Conn.t(), App.Models.User.t()) ::
          {:ok, Plug.Conn.t()}
          | {:error, atom() | Redix.Error.t() | Redix.ConnectionError.t()}

  def create(conn, user) do
    session_id = :crypto.strong_rand_bytes(32) |> Base.url_encode64(padding: false)
    serialized_user = :erlang.term_to_binary(user)

    conn =
      conn
      |> Plug.Conn.put_session(:user_session_id, session_id)

    case Cache.set(session_id, serialized_user, @session_ttl) do
      {:ok, _result} ->
        {:ok, conn}

      {:error, error} ->
        {:error, error}
    end
  end

  @spec get(String.t()) :: {:ok, App.Models.User.t()} | {:error, :not_found}
  def get(session_id) do
    case Cache.get(session_id) do
      {:ok, nil} ->
        {:error, :not_found}

      {:ok, binary_data} ->
        {:ok, :erlang.binary_to_term(binary_data)}
    end
  end

  @spec destroy(Plug.Conn.t(), String.t()) ::
          {:ok, Plug.Conn.t()}
          | {:error, atom() | Redix.Error.t() | Redix.ConnectionError.t()}
  def destroy(conn, session_id) do
    conn =
      conn
      |> Plug.Conn.clear_session()

    case Cache.del(session_id) do
      {:ok, _result} ->
        {:ok, conn}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def session_ttl, do: @session_ttl
end
