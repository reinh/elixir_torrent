defmodule Torrent do
  defrecord Info, meta_info: nil, info_hash: nil, peers: [], pieces: []

  def from_meta(meta) do
    resp = Tracker.announce meta

    Info.new meta_info: meta,
             info_hash: MetaInfo.info_hash(meta),
             peers:     peers_from_response(resp),
             pieces:    pieces_from_meta(meta)
  end

  defp peers_from_response(response) do
    lc <<ip :: [4, binary], port :: [16, big, unsigned, integer]>> inbits response[:peers], do: {ip, port}
  end

  defp pieces_from_meta(meta) do
    lc <<sha :: [20, binary]>> inbits meta[:info][:pieces], do: sha
  end
end
