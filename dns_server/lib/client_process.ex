defmodule DnsServer.ClientProcess do
  use GenServer

  alias DnsServer.LookupProcess
  alias DnsServer.Domain
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

  def resolve(%ServerInfo{client: client}, url) do
    GenServer.call(client, {:resolve, url})
  end

  def resolve(identifier, url) do
    GenServer.call(identifier, {:resolve, url})
  end

  def handle_call({:resolve, url}, _from, %State{lookup: lookup} = state) do
    ret =
      case LookupProcess.best_matching(lookup, url) do
        [] ->
          {:error, :not_found}

        results ->
          case Domain.matching_host(results, url) do
            nil -> {:ok, :retry_at, Domain.servers_only(results)}
            host -> {:ok, host}
          end
      end

    {:reply, ret, state}
  end
end
