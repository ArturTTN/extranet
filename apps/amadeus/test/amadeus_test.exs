defmodule AmadeusTest do
  use ExUnit.Case
  doctest Amadeus

  test "greets the world" do
    assert Amadeus.hello() == :world
  end
end
