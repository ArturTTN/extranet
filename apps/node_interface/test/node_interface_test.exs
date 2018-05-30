defmodule NodeInterfaceTest do
  use ExUnit.Case
  doctest NodeInterface

  test "greets the world" do
    assert NodeInterface.hello() == :world
  end
end
