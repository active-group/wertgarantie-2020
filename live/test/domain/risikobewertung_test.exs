defmodule Live.Domain.RisikobewertungTest do
  use ExUnit.Case

  alias Live.Domain.Risikobewertung

  describe "Risikoberechnung" do
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
end
