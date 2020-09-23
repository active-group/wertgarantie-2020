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

    assert_in_delta Intro.wurzel(1 / 2), 0.7071, 0.001
  end

  test "umfang berechnen" do
    assert_in_delta Intro.umfang(0.5), :math.pi(), 0.00000001
    assert Intro.umfang(0) == 0
    assert_in_delta Intro.umfang(1), 2 * :math.pi(), 0.00000001
  end

  test "contains_do function" do
    refute Intro.contains_do("Hallo")
    assert Intro.contains_do("Sudo")
    assert Intro.contains_do("do end concept")
  end

  # Rechnungen
  def rechnung1(), do: Intro.Rechnung.make("info@example.com", 200.0, false)
  def rechnung2(), do: Intro.Rechnung.make("tim@example.com", -10.0, true)
  def rechnung3(), do: Intro.Rechnung.make("kaan@example.com", 10.0, false)
  def rechnung4(), do: Intro.Rechnung.make("chef@example.com", 2000.0, true)

  def rechnungen_all(), do: [rechnung1(), rechnung2(), rechnung3(), rechnung4()]
  def rechnungen_paid(), do: [rechnung2(), rechnung4()]

  test "all_paid? works" do
    refute Intro.Rechnung.all_paid?(rechnungen_all())
    assert Intro.Rechnung.all_paid?(rechnungen_paid())
  end

  test "all_paid_go_twice? works" do
    refute Intro.Rechnung.all_paid_go_twice?(rechnungen_all())
    assert Intro.Rechnung.all_paid_go_twice?(rechnungen_paid())
  end
end
