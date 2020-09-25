defmodule Live.SchadenCacher do
  @moduledoc """
  Behält den Schaden mit der größten Schadenssumme.
  Wir übermitteln Schädenn an den GenServer.

  Wir benutzen GenServer. Der "State" des GenServers ist genau dieser Schaden,
  und sonst nichts.
  """
  use GenServer
  @vsn 3

  # statt Live.Domain.Schaden.make(...) -> Schaden.make(...)
  alias Live.Domain.Schaden

  # >>> Client Functions
  @spec start_link(Schaden.t()) :: GenServer.on_start()
  def start_link(schaden) do
    GenServer.start_link(__MODULE__, schaden, name: __MODULE__)
    # __MODULE__ ist das eigene Modul, also hier gerade: Live.SchadenCacher
  end

  @doc "Unser Initialer Schaden, den wir aus der Datenkbank lesen"
  @spec init_schaden() :: Schaden.t()
  def init_schaden() do
    # Macht man in echt natürlich auch wirklich dann...
    Schaden.make(1, 20.0, "Bagatelle", 1001)
  end

  @doc "Einen Schaden überprüfen/übermitteln"
  @spec schaden_to_cache(GenServer.server(), Schaden.t()) :: term()
  def schaden_to_cache(server, schaden) do
    GenServer.call(server, {:check, schaden}) # schicke Nachricht {:check, ein_schaden} an GenServer
     # Alternativ GenServer.cast(...) -> wartet nicht auf eine Antwort
     # Unten die Implementierung im Server dann: handle_call ersetzen durch handle_cast
     # und die Rückgabe wäre {:noreply, neuer_zustand} (statt {:reply, ANTWORT, neuer_zustand})

     # Die Nachricht ist an sich sich frei wählbar, denkbar wäre z. B. auch
     # GenServer.call(server, "Überprüfe diesen Schaden hier: Schaden_als_string")
     # -> unten dann: def handle_call("Überprüfe diesen Schaden hier: " <> schaden_als_string, _from, schaden)
     # -> wäre schlechte Nachricht, weil schaden_als_string keine gute Datenstruktur ist
  end


  # <<< Client Functions

  # >>> Server
  @spec init(Schaden.t()) :: {:ok, Schaden.t()}
  def init(schaden) do
    IO.puts("Init SchadenCache with #{inspect(schaden)}")

    {:ok, schaden}
  end

  # schaden ist der alte State
  def handle_call({:check, new_schaden}, _from, schaden) do
    IO.puts("Check Schaden #{inspect(schaden)}")
    max_schaden = Schaden.with_max_amount(schaden, new_schaden)

    # max_schaden ist der neue State
    {:reply, "Checked your schaden. Max Schaden is #{inspect(max_schaden)}", max_schaden}
  end
  # def handle_call(nachricht_die_ankommt, _from, schaden) do
  #   # Muss prüfen ob nachricht_die_ankommt so aussieht wie {:check, schaden}
  #   case nachricht_die_ankommt do
  #     {:check, schaden} -> mache_weiter
  #     alle_anderen_narichten -> tue nichts oder raise oder was auch immer
  #   end
  # end

  # def handle_call(others, _from, state) do
  #   {:reply, "Message unknown", state}
  # end
  # <<< Server

  # Starte den Server mit (wenn manuell):
  # {:ok, pid} = Live.SchadenCacher.start_link(Live.SchadenCacher.init_schaden())

  # Überprüfe einen Schaden mit
  # Live.SchadenCacher.schaden_to_cache(pid, Live.Domain.Schaden.make(1, 20.0, "Bagatelle", 1001))

  # Oder mit Namen: Live-SchadenCacher in unserem Fall
  # Live.SchadenCacher.schaden_to_cache(Live.SchadenCacher, Live.Domain.Schaden.make(1, 20.0, "Bagatelle", 1001))

  ### Hot-Code Upgrade

  @doc """
  Da wir in Live.Domain.Schaden.t() das Feld :amount zu :forecast_amount abgeändert haben, müssen wir unseren
  Zustand des GenServer migrieren.
  """
  @spec code_change(String.t(), %{id: integer(), amount: float(), description: String.t(), partner_nr: integer()}, any()) :: {:ok, Schaden.t()}
  # def code_change(alte_version_vsn, alten_state, _extra) do
  def code_change("1", old_state, _extra) do
    new_state = Schaden.make(old_state.id, old_state.amount, old_state.description, old_state.partner_nr)

    {:ok, new_state}
  end
  # def code_change("2", old_state, _extra) do
  #   mach was anderes
  # end

end
