defmodule Live.Domain.RisikobewertungTest do
  use ExUnit.Case

  alias Live.Domain.Risikobewertung

  defp ein_paar_schäden() do
    [
      Live.Domain.Schaden.make(1, 20.0, "Bagatelle", 1001),
      Live.Domain.Schaden.make(2, 500, "Stoßstange sind heutzutage lackiert", 1001),
      Live.Domain.Schaden.make(3, 400, "Stoßstangen sind heutzutage lackiert", 1002)
    ]
  end

  describe "Risikoberechnung als Integrationstests" do
    @tag :with_database
    test "für Partner ohne Schäden" do
      assert Risikobewertung.calc(99) == Risikobewertung.make(0.0)
    end

    @tag :with_database
    test "für Partner mit der Nummer 1001" do
      assert Risikobewertung.calc(1001) == Risikobewertung.make(52.0)
    end

    @tag :with_database
    test "für Partner mit der Nummer 1002" do
      assert Risikobewertung.calc(1002) == Risikobewertung.make(200.0)
    end
  end

  describe "Risikoberechnung der Berechnung" do
    test "für Partner ohne Schäden" do
      assert Risikobewertung.calc_helper(
               Live.Domain.Partner.make(99, 2016),
               ein_paar_schäden(),
               2020
             ) == Risikobewertung.make(0.0)
    end

    test "für Partner mit der Nummer 1001" do
      assert Risikobewertung.calc_helper(
               Live.Domain.Partner.make(1001, 2011),
               ein_paar_schäden(),
               2020
             ) == Risikobewertung.make(52.0)
    end

    test "für Partner mit der Nummer 1002" do
      assert Risikobewertung.calc_helper(
               Live.Domain.Partner.make(1002, 2019),
               ein_paar_schäden(),
               2020
             ) == Risikobewertung.make(200.0)
    end
  end
end
