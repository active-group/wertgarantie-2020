defmodule Live.Domain.SchadenTest do
  use ExUnit.Case
  use PropCheck
  doctest Live.Domain.Schaden

  alias Live.Domain.Schaden

  setup_all do
    # Z. B.
    # Starte Testdatenbank, gegen die Integrationstest laufen gelassen werden

    s1 = Schaden.make(1, 20.0, "Bagatelle", 1001)

    s2 =
      Schaden.make(2, 500, "Stoßstangen sind heutzutage lackiert, da wirds schnell teuer", 9999)

    s3 = Schaden.make(4, 10, "Stoßstangen sind heutzutage lackiert", 9999)

    # Auch Ausgangstätigkeiten möglich:
    # on_exit(fn -> IO.puts("Bin fertig") end)

    {:ok, s20: s1, s500: s2, s10: s3}
  end

  test "schaden with higher amount", %{s20: s20, s500: s_der_gewinnt} do
    # s1 = %Schaden{id: 1, forecast_amount: 20.0, description: "Bagatelle", partner_nr: 100}

    assert Schaden.with_max_amount(s20, s_der_gewinnt) == s_der_gewinnt
  end

  test "schaden with equals amount", %{s20: s1} do
    assert Schaden.with_max_amount(s1, %{s1 | description: "Andere Bagatelle"}) == s1
  end

  test "sort schaden along amount" do
    assert Schaden.sort_along_amount([
             Schaden.make(2, 500, "Stoßstangen sind heutzutage lackiert", 9999),
             Schaden.make(1, 20.0, "Bagatelle", 1001),
             Schaden.make(3, 500, "Stoßstangen sind heutzutage lackiert", 9999),
             Schaden.make(4, 10, "Stoßstangen sind heutzutage lackiert", 9999)
           ]) ==
             [
               Schaden.make(4, 10, "Stoßstangen sind heutzutage lackiert", 9999),
               Schaden.make(1, 20.0, "Bagatelle", 1001),
               Schaden.make(2, 500, "Stoßstangen sind heutzutage lackiert", 9999),
               Schaden.make(3, 500, "Stoßstangen sind heutzutage lackiert", 9999)
             ]

    assert Schaden.sort_along_amount([]) |> Enum.empty?()
  end

  describe "Schadenssumme" do
    test "für die leere Liste" do
      assert Schaden.amount_sum([]) == 0.0
    end

    test "für eine Liste mit einem Element" do
      s1 = Schaden.make(1, 20.0, "Bagatelle", 1001)

      assert Schaden.amount_sum([s1]) == 20.0
    end

    test "für eine Liste mit zwei Elementen" do
      s1 = Schaden.make(1, 20.0, "Bagatelle", 1001)
      s2 = Schaden.make(2, 500, "Stoßstangen sind heutzutage lackiert", 9999)

      assert Schaden.amount_sum([s1, s2]) == 520.0
    end

    test "für eine Liste mit mehr als zwei Elementen" do
      s1 = Schaden.make(1, 20.0, "Bagatelle", 1001)
      s2 = Schaden.make(2, 500, "Stoßstangen sind heutzutage lackiert", 9999)
      s3 = Schaden.make(4, 10, "Stoßstangen sind heutzutage lackiert", 9999)

      assert Schaden.amount_sum([s1, s2, s3]) == 530.0
    end
  end

  describe "Gehört zu Partner" do
    # was ist der einfachste Fall?
    test "bei keinen Schäden" do
      assert Schaden.belongs_to_partner?([], 1001)
    end

    test "bei Schäden die alle dem Partner gehören", %{s500: s500, s10: s10} do
      assert Schaden.belongs_to_partner?([s500, s10], 9999)
    end

    test "bei Schäden die alle nicht dem Partner gehören", %{s500: s500, s10: s10} do
      refute Schaden.belongs_to_partner?([s500, s10], 8888)
    end

    test "bei Schäden wo einer nicht dem Partner gehört", %{s500: s500, s10: s10, s20: s20} do
      refute Schaden.belongs_to_partner?([s500, s10, s20], 9999)
    end
  end

  describe "Gehört zu Partner mit Warnmeldung" do
    # was ist der einfachste Fall?
    test "bei keinen Schäden" do
      assert ExUnit.CaptureLog.capture_log(fn ->
               assert Schaden.belongs_to_partner_with_logging?([], 1001)
             end) =~ "Called belongt_to_partner? with empty list and partner_nummer '1001'"
    end

    test "bei Schäden die alle dem Partner gehören", %{s500: s500, s10: s10} do
      assert ExUnit.CaptureLog.capture_log(fn ->
               assert Schaden.belongs_to_partner_with_logging?([s500, s10], 9999)
             end) == ""
    end

    test "bei Schäden die alle nicht dem Partner gehören", %{s500: s500, s10: s10} do
      refute Schaden.belongs_to_partner_with_logging?([s500, s10], 8888)
    end

    test "bei Schäden wo einer nicht dem Partner gehört", %{s500: s500, s10: s10, s20: s20} do
      refute Schaden.belongs_to_partner_with_logging?([s500, s10, s20], 9999)
    end
  end

  property "das Quadrat von Zahlen ist nicht negativ" do
    forall n <- integer() do
      assert n * n >= 0
    end
  end

  defp non_neg_float_gen() do
    such_that(n <- float(), when: n >= 0.0)
  end

  defp schaden_gen() do
    let(
      [
        id <- pos_integer(),
        forecast_amount <- non_neg_float_gen(),
        description <- utf8(8),
        partner_nr <- pos_integer()
      ],
      do: Schaden.make(id, forecast_amount, description, partner_nr)
    )
  end

  # Generiert Liste mit zwei Schäden
  defp list_with_two_schäden_gen() do
    let(
      [
        first <- schaden_gen(),
        second <- schaden_gen()
      ],
      do: [first, second]
    )
  end

  property "Summe von einem Schaden mit nicht negativer Schadenssumme ist nicht negativ" do
    forall schaden <- schaden_gen() do
      assert Schaden.amount_sum([schaden]) >= 0
    end
  end

  property "Summe einer Liste aus (nicht negativen) Schäden ist nicht negativ" do
    forall schäden <- list(schaden_gen()) do
      assert Schaden.amount_sum(schäden) >= 0
    end
  end

  # assert Schaden.with_max_amount(s500, s20) == s500
  # Schaden.sort_along_amount([s500, s20]) == [s20, s500]
  property "Bei einer Liste mit zwei sortierten Schäden, gewinnt immer der zweite Schaden" do
    forall two_schäden <- list_with_two_schäden_gen() do
      [low, high] = Schaden.sort_along_amount(two_schäden)
      # IO.inspect([low, high])

      assert Schaden.with_max_amount(low, high) == high
      assert Schaden.with_max_amount(high, low) == high
    end
  end
end
