defmodule DnsServer.RegistryProcess do
  use GenServer
  alias DnsServer.LookupProcess
  alias DnsServer.Domain.ServerInfo

  defmodule State do
    use QuickStruct, lookup: identifier()
  end

  def start_link(name: name, lookup: lookup) do
    GenServer.start_link(__MODULE__, [lookup], name: name)
  end

  def init([lookup]) do
    {:ok, State.make(lookup)}
  end

  def register_child(%ServerInfo{registry: registry}, child_info) do
    GenServer.cast(registry, {:register_child, child_info})
  end

  def register_child(identifier, child_info) do
    GenServer.cast(identifier, {:register_child, child_info})
  end

  def handle_cast({:register_child, child_info}, %State{lookup: lookup} = state) do
    LookupProcess.put(lookup, child_info)
    {:noreply, state}
  end
end
