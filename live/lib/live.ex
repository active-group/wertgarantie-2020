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

  ### Release bauen mit distillery ###
  #
  # MIX_ENV=prod mix distillery.release
  #
  # Kopiere dann _build/prod/rel/live z. B. nach /tmp/
  #
  # Starte das Release dann mit:
  #
  #    /tmp/live/bin/live console
  #
  ###
end
