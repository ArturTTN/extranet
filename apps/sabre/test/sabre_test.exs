defmodule SabreTest do
  use ExUnit.Case
  doctest Sabre

  test "greets the world" do
    assert Sabre.hello() == :world
  end
end
