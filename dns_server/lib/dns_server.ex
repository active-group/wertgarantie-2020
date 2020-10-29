defmodule DnsServer do
  use Supervisor

  alias DnsServer.LookupProcess
  alias DnsServer.RegistryProcess
  alias DnsServer.ClientProcess
  alias DnsServer.Domain
  alias DnsServer.Domain.ServerInfo
  alias DnsServer.Client

  def setup do
    root = DnsServer.start(name: :root, namespace: [])
    org = DnsServer.start(name: :org, namespace: ["org"])
    wikipedia = DnsServer.start(name: :wikipedia, namespace: ["wikipedia", "org"])

    IO.inspect(root)

    host1 = Domain.HostInfo.make("de.wikipedia.org", "10.5.10.2")
    host2 = Domain.HostInfo.make("de.wikipedia.org", "10.5.10.3")

    RegistryProcess.register_child(root, org)
    RegistryProcess.register_child(org, wikipedia)
    RegistryProcess.register_child(wikipedia, host1)
    RegistryProcess.register_child(wikipedia, host2)

    IO.inspect(Client.resolve(root, "de.wikipedia.org", &ClientProcess.resolve/2))

    :ok
  end

  @spec with_suffix(atom(), String.t()) :: atom()
  def with_suffix(atom, suffix) do
    new_string_name = Atom.to_string(atom) <> suffix
    String.to_atom(new_string_name)
  end

  @spec start(name: atom(), namespace: Domain.namespaces_t()) :: ServerInfo.t()
  def start(name: name, namespace: namespace) do
    registry_name = {:global, with_suffix(name, "_registry")}
    lookup_name = {:global, with_suffix(name, "_lookup")}
    client_name = {:global, with_suffix(name, "_client")}

    Supervisor.start_link(
      __MODULE__,
      [registry: registry_name, lookup: lookup_name, client: client_name],
      name: {:global, name}
    )

    ServerInfo.make({:global, name}, namespace, registry_name, client_name)
  end

  def init(registry: registry_name, lookup: lookup_name, client: client_name) do
    children = [
      {LookupProcess, [name: lookup_name]},
      {ClientProcess, [name: client_name, lookup: lookup_name]},
      {RegistryProcess, [name: registry_name, lookup: lookup_name]}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
