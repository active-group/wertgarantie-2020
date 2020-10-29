defmodule DnsServer.LookupProcess do
  use GenServer
  alias DnsServer.Lookup
  alias DnsServer.Domain

  def start_link(name: name) do
    GenServer.start_link(__MODULE__, [], name: name)
  end

  def init([]) do
    {:ok, DnsServer.Lookup.init()}
  end

  @doc """
  Returns the closest matches, available in the lookup
  """
  @spec best_matching(identifier(), Domain.uri_t()) :: [Domain.dns_element()]
  def best_matching(identifier, url) do
    GenServer.call(identifier, {:best_matching, url})
  end

  @doc """
  Puts a new entry into the lookup
  """
  @spec put(identifier(), Domain.dns_element()) :: :ok
  def put(identifier, entry) do
    GenServer.cast(identifier, {:put, entry})
  end

  def remove_server_by_name(identifier, name) do
    GenServer.cast(identifier, {:remove_server_by_name, name})
  end

  def handle_call({:best_matching, url}, _from, lookup) do
    matches = Lookup.best_matching(lookup, url)
    {:reply, matches, lookup}
  end

  def handle_cast({:remove_server_by_name, name}, lookup) do
    next_lookup = Lookup.remove_server_by_name(lookup, name)
    {:noreply, next_lookup}
  end

  def handle_cast({:put, entry}, lookup) do
    next_lookup = Lookup.put(lookup, entry)
    {:noreply, next_lookup}
  end
end
