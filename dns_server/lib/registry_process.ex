defmodule DnsServer.RegistryProcess do
  use GenServer
  alias DnsServer.LookupProcess
  alias DnsServer.Domain.ServerInfo

  defmodule State do
    use QuickStruct, lookup: identifier(), pid_name_mapping: %{}
  end

  def start_link(name: name, lookup: lookup) do
    GenServer.start_link(__MODULE__, [lookup], name: name)
  end

  def init([lookup]) do
    {:ok, State.make(lookup, %{})}
  end

  def register_child(%ServerInfo{registry: registry}, child_info) do
    GenServer.cast(registry, {:register_child, child_info})
  end

  def register_child(identifier, child_info) do
    GenServer.cast(identifier, {:register_child, child_info})
  end

  def handle_cast(
        {:register_child, child_info},
        %State{lookup: lookup, pid_name_mapping: m} = state
      ) do
    next_mapping =
      case child_info do
        %ServerInfo{name: {:global, name}} ->
          pid = :global.whereis_name(name)
          Process.monitor(pid)
          Map.put(m, pid, {:global, name})

        _host ->
          m
      end

    LookupProcess.put(lookup, child_info)
    {:noreply, %State{state | pid_name_mapping: next_mapping}}
  end

  def handle_info({:DOWN, _, _, pid, _}, %State{lookup: lookup, pid_name_mapping: m} = state) do
    name = Map.get(m, pid)
    LookupProcess.remove_server_by_name(lookup, name)
    {:noreply, state}
  end
end
