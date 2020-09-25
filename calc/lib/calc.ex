defmodule Calc do
  @moduledoc """
  Documentation for `Calc`.
  """
  use Application

  @impl true
  def start(_type, _args) do
    # Lese Port aus config/config.exs
    port = Application.get_env(:calc, Server)[:port]
    Server.Supervisor.start_link(port)
  end
end
