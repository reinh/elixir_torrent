defmodule PeerProtocol do
  @pstrlen "19"
  @pstr "BitTorrent protocol"
  @reserved "00000000"

  def handshake(torrent) do
    @pstrlen <>
      @pstr <>
      @reserved <>
      torrent.info_hash <>
      ElixirTorrent.peer_id
  end
end
