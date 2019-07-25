defmodule MetrexTest do
  use ExUnit.Case
  doctest Metrex

  test "greets the world" do
    assert Metrex.hello() == :world
  end
end
