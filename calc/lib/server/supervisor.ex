defmodule Server.Supervisor do
  @moduledoc """
  Kontrolliert den Server (GenServer/TCP-Server)
  """
  use Supervisor

  # State ist der Port, wird bis zum Server durch gereichet
  def start_link(port) do
    Supervisor.start_link(__MODULE__, port, name: __MODULE__)
  end

  def init(port) do
    children = [
      {Task.Supervisor, name: Server.MyTaskSupervisor},
      worker(Server, [port], restart: :permanent)
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
