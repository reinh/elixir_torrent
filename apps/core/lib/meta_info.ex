defmodule MetaInfo do
  def info_hash(meta_info) do
    meta_info[:info] |> Bencode.encode |> Sha.binary
  end

  def total_size(meta_info) do
    case meta_info[:info][:length] do
      value -> value
      nil   ->
        meta_info[:info][:files]
          |> Enum.map(Dict.get(&1, :length))
          |> Enum.reduce(0, &1+&2)
    end
  end

  def announce_uri(meta_info) do
    meta_info[:announce]
      |> URI.parse
      |> UriHelper.with_params [
        info_hash:  info_hash(meta_info),
        left:       total_size(meta_info),
        peer_id:    "00000000000000000000",
        port:       12345,
        uploaded:   0,
        downloaded: 0,
        compact:    1
      ]
  end

  def announce_url(meta_info), do: announce_uri(meta_info) |> to_binary
end
