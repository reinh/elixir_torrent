defmodule Sha do
  def hex(data) do
    <<int::160>> = sha data
    [hex] = :io_lib.format '~40.16.0b', [int]
    to_binary hex
  end

  def binary(data), do: sha data

  defp sha(data), do: :crypto.sha data
end
