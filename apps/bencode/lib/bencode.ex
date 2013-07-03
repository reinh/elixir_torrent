defmodule Bencode do
  # The type of Dict to use for decoded dictionaries.
  @dict ListDict

  @moduledoc """
  This module provides <strike>encoding</strike> and decoding functionality for
  [Bencoded][] binary data.

  ## Examples

      Bencode.decode(<<"4:spam">>)
      # => {"spam", ""}

  [Bencoded]: https://wiki.theory.org/BitTorrentSpecification#Bencoding
  """

  @doc """
  Decode binary data in Bencode format.

  data - the binary bencoded data to decode.

  Returns a tuple, `{data, tail}`, of the decoded data and any trailing data.
  """
  def decode(<<?i, tail :: binary>>), do: decode_int  tail, []
  def decode(<<?l, tail :: binary>>), do: decode_list tail, []
  def decode(<<?d, tail :: binary>>), do: decode_dict tail, @dict.new
  def decode(data),                   do: decode_str  data, []

  defp decode_int(<<?e, tail :: binary>>, acc), do: {to_int(acc), tail}
  defp decode_int(<< h, tail :: binary>>, acc), do: decode_int tail, [h|acc]

  defp decode_list(<<?e, tail :: binary>>, acc), do: {Enum.reverse(acc), tail}
  defp decode_list(data, acc) do
    {head, tail} = decode data
    decode_list tail, [head|acc]
  end

  defp decode_dict(<<?e, tail :: binary>>, acc), do: {acc, tail}
  defp decode_dict(data, acc) do
    {key, tail} = decode data
    {value, _tail} = decode tail
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
