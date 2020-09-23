defmodule IntroTest do
  use ExUnit.Case
  doctest Intro

  test "greets the world" do
    assert Intro.hello() == :world
    refute Intro.hello() == :world2
  end

  test "die Wurzel-Funktion" do
    assert Intro.wurzel(4) == 2.0
    assert Intro.wurzel(256) == 16
    assert Intro.wurzel(1) == 1
  end
end
