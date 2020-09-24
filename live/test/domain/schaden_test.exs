defmodule Live.Domain.SchadenTest do
  use ExUnit.Case

  alias Live.Domain.Schaden

  test "schaden with higher amount" do
    s1 = Schaden.make(1, 20.0, "Bagatelle", 1001)

    s2 =
      Schaden.make(2, 500, "Stoßstangen sind heutzutage lackiert, da wirds schnell teuer", 9999)

    assert Schaden.with_max_amount(s1, s2) == s2
  end

  test "schaden with equals amount" do
    s1 = Schaden.make(1, 20.0, "Bagatelle", 1001)

    assert Schaden.with_max_amount(s1, %{s1 | description: "Andere Bagatelle"}) == s1
  end
end
