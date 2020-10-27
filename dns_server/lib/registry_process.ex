defmodule DnsServer.RegistryProcess do
  use GenServer
  alias DnsServer.Lookup

  defmodule State do
    use QuickStruct, lookup: identifier()
  end

  def start_link(name: name, lookup: lookup) do
    GenServer.start_link(__MODULE__, [lookup], name: name)
  end

  def init([lookup]) do
    {:ok, State.make(lookup)}
  end

  def register_child(identifier, child_info) do
    GenServer.cast(identifier, {:register_child, child_info})
  end

  def handle_cast({:register_child, child_info}, %State{lookup: lookup} = state) do
    Lookup.put(lookup, child_info)
    {:noreply, state}
  end
end
