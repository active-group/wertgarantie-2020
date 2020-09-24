defmodule Live.SchadenCacher do
  @moduledoc """
  Behält den Schaden mit der größten Schadenssumme.
  Wir übermitteln Schädenn an den GenServer.

  Wir benutzen GenServer. Der "State" des GenServers ist genau dieser Schaden,
  und sonst nichts.
  """
  use GenServer
  @vsn 1

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
    GenServer.call(server, {:check, schaden})
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

  # def handle_call(others, _from, state) do
  #   {:reply, "Message unknown", state}
  # end
  # <<< Server

  # Starte den Server mit (wenn manuell):
  # {:ok, pid} = Live.SchadenCacher.start_link(Live.SchadenCacher.init_schaden())

  # Überprüfe einen Schaden mit
  # Live.SchadenCacher.schaden_to_cache(pid, Live.Domain.Schaden.make(1, 20.0, "Bagatelle", 1001))

  # # Live.SchadenCacher.schaden_to_cache(Live.SchadenCacher, Live.Domain.Schaden.make(1, 20.0, "Bagatelle", 1001))
end
