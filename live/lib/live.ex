defmodule Live do
  @moduledoc """
  Documentation for `Live`.
  """
  use Application

  @impl true
  def start(_type, _args) do
    Live.Supervisor.start_link([])
  end
end

defmodule Live.Supervisor do
  @moduledoc """
  Überwacht unseren Live.SchadenCacher GenServer
  """

  use Supervisor

  def start_link(state) do
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(_state) do
    children = [
      worker(Live.SchadenCacher, [Live.SchadenCacher.init_schaden()], restart: :permanent)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  # Starte den Supervisor mit (wenn manuell):
  # Live.Supervisor.start_link([])

  ### Release bauen mit Distillery ###
  #
  #    MIX_ENV=prod mix distillery.release
  #
  # Kopiere dann _build/prod/rel/live z. B. nach /tmp/
  #
  # Starte das Release dann mit:
  #
  #    /tmp/live/bin/live console
  #
  # Dies lässt eine Konsole offen, nicht geeignet für den tatsächlichen Serverbetrieb.
  ###

  ### Release als Upgrade bauen ###
  #
  #    MIX_ENV=prod mix distillery.release --upgrade
  #
  # Lege ein releases/VERSIONSNR Ordner am Zielort an, z. B.
  #
  #    mkdir /tmp/live/releases/0.1.2
  #
  # Kopiere den tar-ball des Release dort hin, z. B.
  #
  #    cp _build/prod/rel/live/releases/0.1.2/live.tar.gz /tmp/live/releases/0.1.2/
  #
  # Upgrade das parallel laufende Release mit z. B.
  #
  #    /tmp/live/bin/live upgrade "0.1.2"
  #
  # Downgrade ebenso möglich mit z. B.
  #
  #    /tmp/live/bin/live downgrade "0.1.0"
  #
  ###
end
