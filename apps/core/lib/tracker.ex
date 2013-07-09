defmodule Tracker do
  def announce(meta) do
    {:ok, data} = meta
      |> MetaInfo.announce_url
      |> HTTPotion.get
      |> HTTPotion.Response.body
      |> Bencode.decode
    data
  end
end
