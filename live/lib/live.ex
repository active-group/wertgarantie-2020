defmodule Live do
  @moduledoc """
  Documentation for `Live`.
  """
end

defmodule Live.Supervisor do
  @moduledoc """
  Überwacht unseren Live.SchadenCacher GenServer
  """

  use Supervisor

  def start_link(state) do
    Supervisor.start_link(__MODULE__, state, name: __MODULE__)
  end

  @spec init(any) :: {:ok, {%{intensity: any, period: any, strategy: any}, [any]}}
  def init(_state) do
    children = [
      worker(Live.SchadenCacher, [Live.SchadenCacher.init_schaden()], restart: :permanent)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  # Starte den Supervisor mit (wenn manuell):
  # Live.Supervisor.start_link([])
end
