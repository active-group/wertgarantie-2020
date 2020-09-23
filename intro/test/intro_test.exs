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

    assert_in_delta Intro.wurzel(1/2), 0.7071, 0.001
  end

  test "umfang berechnen" do
    assert_in_delta Intro.umfang(0.5), :math.pi, 0.00000001
    assert Intro.umfang(0) == 0
  end
end
