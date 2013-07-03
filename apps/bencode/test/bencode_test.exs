Code.require_file "test_helper.exs", __DIR__

defmodule BencodeTest do
  use ExUnit.Case

  test "decoding an integer" do
    assert Bencode.decode(<<"i3e">>)  == { 3, <<"">>}
    assert Bencode.decode(<<"i5e">>)  == { 5, <<"">>}
    assert Bencode.decode(<<"i15e">>) == {15, <<"">>}
  end

  test "decoding a string" do
    assert Bencode.decode(<<"4:spam">>) == {"spam", <<"">>}
    assert Bencode.decode(<<"4:eggs">>) == {"eggs", <<"">>}
  end

  test "decoding a list" do
    assert Bencode.decode(<<"l4:spam4:eggse">>) == {["spam", "eggs"], <<"">>}
  end

  test "decoding a dictionary" do
    given = <<"d3:cow3:moo4:spam4:eggse">>
    expected = [ cow: "moo", spam: "eggs" ]
    assert Bencode.decode(given) == {expected, ""}
  end

end
