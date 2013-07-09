defmodule ElixirTorrent do
  @client_abbreviation "EX"
  @version "0000"
  @specifier "00000000000000"

  def peer_id, do: @client_abbreviation <> @version <> @specifier
end
