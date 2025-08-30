defmodule App.Cache do
  defp command(command) do
    Redix.command(:redix, command)
  end

  def set(key, value, ttl) do
    command(["SET", key, value, "EX", ttl])
  end

  def get(key) do
    command(["GET", key])
  end

  def del(key) do
    command(["DEL", key])
  end

  def exists?(key) do
    case command(["EXISTS", key]) do
      {:ok, 1} -> true
      {:ok, 0} -> false
      {:error, _} -> false
    end
  end
end
