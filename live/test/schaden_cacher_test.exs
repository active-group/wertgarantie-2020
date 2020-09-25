defmodule Live.SchadenCacher.Test do
  use ExUnit.Case, async: false

  test "get schaden" do
    assert Live.SchadenCacher.get(Live.SchadenCacher) == Live.SchadenCacher.init_schaden()
  end

  test "check schaden" do
    mein_schaden = Live.Domain.Schaden.make(1, 30.0, "Bagatelle", 1001)

    assert Live.SchadenCacher.schaden_to_cache(Live.SchadenCacher, mein_schaden) ==
             "Checked your schaden. Max Schaden is %Live.Domain.Schaden{description: \"Bagatelle\", forecast_amount: 30.0, id: 1, partner_nr: 1001}"

    assert Live.SchadenCacher.get(Live.SchadenCacher) == mein_schaden

    # Müssen GenServer noch neustarten, dass der andere Test funktioniert.
    # Tun dies, indem wir ihn beenden, wird dann automatisch neugestartet.
    Process.whereis(Live.SchadenCacher)
    |> Process.exit(:kill)

    # Noch kurz warten, bis im Hintergrund GenServer wieder gestartet ist.
    # 1ms
    Process.sleep(1)
  end
end
