defmodule Bencode.Mixfile do
  use Mix.Project

  def project do
    [ app: :core,
      version: "0.0.1",
      elixir: "~> 0.9.4-dev",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    []
  end

  # Returns the list of dependencies in the format:
  # { :foobar, "0.1", git: "https://github.com/elixir-lang/foobar.git" }
  defp deps do
    [
      { :httpotion, github: "myfreeweb/httpotion" },
      { :ex_doc, github: "elixir-lang/ex_doc" },
      { :monad, github: "nickmeharry/elixir-monad" }
    ]
  end
end
