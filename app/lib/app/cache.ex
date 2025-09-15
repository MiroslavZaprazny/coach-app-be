defmodule App.Cache do
  defp command(command) do
    Redix.command(:redix, command)
  end

  @type redix_command_return ::
          {:ok, Redix.Protocol.redis_value()}
          | {:error, atom() | Redix.Error.t() | Redix.ConnectionError.t()}

  @spec set(String.t(), binary(), integer()) :: redix_command_return()
  def set(key, value, ttl) do
    command(["SET", key, value, "EX", ttl])
  end

  @spec get(String.t()) :: redix_command_return()
  def get(key) do
    command(["GET", key])
  end

  @spec del(String.t()) :: redix_command_return()
  def del(key) do
    command(["DEL", key])
  end

  @spec exists?(String.t()) :: boolean()
  def exists?(key) do
    case command(["EXISTS", key]) do
      {:ok, 1} -> true
      {:ok, 0} -> false
      {:error, _} -> false
    end
  end
end
