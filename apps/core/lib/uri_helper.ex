defmodule UriHelper do
  def with_params(uri, params) do
    Enum.reduce params, uri, with_param(&1, &2)
  end

  def with_param({k, v}, uri), do: with_param(uri, k, v)
  def with_param(uri, {k, v}), do: with_param(uri, k, v)
  def with_param(uri, k, v) do
    query = uri.query || ""
    query = query
      |> URI.decode_query
      |> Dict.put(k, v)
      |> URI.encode_query
    uri.update(query: query)
  end
end
