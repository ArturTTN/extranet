defmodule SessionManagerTest do
  use ExUnit.Case
  doctest SessionManager

  test "greets the world" do
    assert SessionManager.hello() == :world
  end
end
