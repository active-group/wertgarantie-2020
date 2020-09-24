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

  # Lastschrift
  def lastschrift1(), do: Intro.Lastschrift.make("DE02120300000000202051", 20.0, false)
  def lastschrift2(), do: Intro.Lastschrift.make("DE02500105170137075030", 30.0, true)
  def lastschrift3(), do: Intro.Lastschrift.make("DE0210050000005454040", 27.42, false)

  test "lastschrift has valid iban?" do
    assert Intro.Lastschrift.has_valid_iban?(lastschrift1())
    assert Intro.Lastschrift.has_valid_iban?(lastschrift2())
    refute Intro.Lastschrift.has_valid_iban?(lastschrift3())
  end

  # Zahlungen
  test "got money?" do
    refute Intro.got_money?(rechnung1())
    assert Intro.got_money?(rechnung2())

    refute Intro.got_money?(lastschrift1())
    assert Intro.got_money?(lastschrift2())
  end

  test "fibonacci" do
    assert Intro.fibonacci(1) == 1
    assert Intro.fibonacci(2) == 1
    assert Intro.fibonacci(3) == 2
    assert Intro.fibonacci(4) == 3
    assert Intro.fibonacci(5) == 5
    assert Intro.fibonacci(6) == 8
    assert Intro.fibonacci(7) == 13
    assert Intro.fibonacci(8) == 21
    assert Intro.fibonacci(9) == 34
    assert Intro.fibonacci(10) == 55
  end

  test "readme is long enough?" do
    refute Intro.readme_long_enough?("README.md")
    assert Intro.readme_long_enough?("mix.exs")
    refute Intro.readme_long_enough?("mich-gibt-esnicht-als-datei.txt")
  end

  test "readme is long enough? can raise" do
    refute Intro.readme_long_enough_can_raise?("README.md")
    assert Intro.readme_long_enough_can_raise?("mix.exs")
    assert_raise File.Error, fn ->
      Intro.readme_long_enough_can_raise?("mich-gibt-esnicht-als-datei.txt")
    end
  end
end
