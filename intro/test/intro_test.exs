defmodule IntroTest do
  use ExUnit.Case
  doctest Intro

  test "greets the world" do
    assert Intro.hello() == :world
    refute Intro.hello() == :world2
  end
end
