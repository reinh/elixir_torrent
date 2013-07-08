defmodule Bencode do
  @moduledoc """
  This module provides <strike>encoding</strike> and decoding functionality for
  [Bencoded][] binary data.

  ## Examples

      Bencode.decode(<<"4:spam">>)
      # => "spam"

      Bencode.decode_file("path/to/a.torrent")

  [Bencoded]: https://wiki.theory.org/BitTorrentSpecification#Bencoding
  """

  import Monad

  @doc """
  Read and decode a file.

  Returns {:ok, result} or {:error, reason}
  """
  def decode_file(fh) do
    monad ErrorM do
      contents <- File.read(fh)
      decode contents
    end
  end

  @doc """
  Returns the decoded data or raises an error.
  """
  def decode_file!(fh) do
    {:ok, data} = decode_file(fh)
    data
  end

  @doc """
  Encode Erlang terms in Bencode format.
  """
  def encode(term) when is_integer(term), do: "i#{term}e"
  def encode(term) when is_binary(term),  do: "#{byte_size(term)}:#{term}"
  def encode(term) when is_list(term),    do: "l#{Enum.map(term, encode(&1))}e"
  def encode(term), do: "d" <> encode_dict(term) <> "e"

  defp encode_dict(dict) do
    dict |> Enum.to_list |> Enum.sort |> Enum.map_join(encode_pair(&1))
  end

  defp encode_pair({k, v}) do
    [atom_to_binary(k), v] |> Enum.map_join(encode(&1))
  end

  @doc """
  Decode binary data in Bencode format.

  data - the binary bencoded data to decode.

  Returns {:ok, result} or {:error, reason}
  """
  def decode(data) do
    case _decode(data) do
      {result, ""}   -> {:ok, result}
      {result, rest} -> {:error, "Incomplete decode with remainder #{rest}"}
    end
  end

  defp _decode(<<?i, tail :: binary>>), do: decode_int  tail, []
  defp _decode(<<?l, tail :: binary>>), do: decode_list tail, []
  defp _decode(<<?d, tail :: binary>>), do: decode_dict tail, HashDict.new
  defp _decode(data),                   do: decode_str  data, []

  defp decode_int(<<?e, tail :: binary>>, acc), do: {to_int(acc), tail}
  defp decode_int(<< h, tail :: binary>>, acc), do: decode_int tail, [h|acc]

  defp decode_list(<<?e, tail :: binary>>, acc), do: {Enum.reverse(acc), tail}
  defp decode_list(data, acc) do
    {head, tail} = _decode data
    decode_list tail, [head|acc]
  end

  defp decode_dict(<<?e, tail :: binary>>, acc), do: {acc, tail}
  defp decode_dict(data, acc) do
    {key, tail} = _decode data
    {value, _tail} = _decode tail
    decode_dict _tail, Dict.put(acc, binary_to_atom(key), value)
  end

  defp decode_str(<<?:, tail :: binary>>, acc) do
    int = to_int acc
    <<string :: [binary, size(int)], _tail :: binary>> = tail
    {string, _tail}
  end
  defp decode_str(<< h, tail :: binary>>, acc), do: decode_str tail, [h|acc]

  defp to_int(list), do: list_to_integer Enum.reverse list
end
