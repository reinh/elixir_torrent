Code.require_file "test_helper.exs", __DIR__

defmodule BencodeTest do
  use ExUnit.Case

  test "decoding an integer" do
    assert Bencode.decode(<<"i3e">>)  ==  {:ok,  3}
    assert Bencode.decode(<<"i5e">>)  ==  {:ok,  5}
    assert Bencode.decode(<<"i15e">>) ==  {:ok, 15}
  end

  test "decoding a string" do
    assert Bencode.decode(<<"4:spam">>) == {:ok, "spam"}
    assert Bencode.decode(<<"4:eggs">>) == {:ok, "eggs"}
  end

  test "decoding a list" do
    assert Bencode.decode(<<"l4:spam4:eggse">>) == {:ok, ["spam", "eggs"]}
  end

  test "decoding a dictionary" do
    data = <<"d3:cow3:moo4:spam4:eggse">>
    expected = HashDict.new([ cow: "moo", spam: "eggs" ])
    {:ok, given} = Bencode.decode(data)
    assert Dict.equal?(expected, given)
  end

  test "encoding an integer" do
    assert Bencode.encode(3)  == <<"i3e">>
    assert Bencode.encode(5)  == <<"i5e">>
    assert Bencode.encode(15) == <<"i15e">>
  end

  test "encoding a string" do
    assert Bencode.encode("spam") == <<"4:spam">>
  end

  test "encoding a list" do
    assert Bencode.encode(["spam", "eggs"]) == <<"l4:spam4:eggse">>
  end

  test "encoding a dict" do
    given = HashDict.new([ spam: "eggs", cow: "moo" ])
    expected = <<"d3:cow3:moo4:spam4:eggse">>

    assert Bencode.encode(given) == expected
  end

  test "decoding a nonexistant file" do
    assert Bencode.decode_file "nonesuch" == {:error, :enoent}
  end
end
