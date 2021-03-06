defmodule DnsServer.Domain do
  @type uri_t :: String.t()
  @type zone_t :: String.t()
  @type namespaces_t :: [zone_t()]
  @type address_t :: String.t()

  defmodule ServerInfo do
    @moduledoc """
    Contains all information that describe a server uniquely
    Contains all information needed to contact a server
    """
    alias DnsServer.Domain

    use QuickStruct,
      name: identifier(),
      namespace: Domain.namespaces_t(),
      registry: identifier(),
      client: identifier()

    @spec matches_namespace?(DnsServer.Domain.ServerInfo.t(), Domain.namespace_t()) :: boolean
    def matches_namespace?(%ServerInfo{namespace: namespace}, other_namespace) do
      namespace == other_namespace
    end
  end

  defmodule HostInfo do
    @moduledoc """
    Contains a URI and an address of a host
    """
    alias DnsServer.Domain

    use QuickStruct,
      uri: Domain.uri_t(),
      address: Domain.address_t()

    @spec matches_namespace?(DnsServer.Domain.HostInfo.t(), Domain.namespaces_t()) :: boolean
    def matches_namespace?(%HostInfo{uri: uri}, namespace) do
      Enum.join(namespace, ".") == uri
    end

    def matches_uri?(%HostInfo{uri: uri}, other_uri) do
      uri == other_uri
    end
  end

  @type dns_element ::
          ServerInfo.t() | HostInfo.t()

  def matching_host(elems, uri) do
    Enum.filter(elems, fn
      %HostInfo{} = host -> HostInfo.matches_uri?(host, uri)
      %ServerInfo{} -> false
    end)
    |> List.first()
  end

  def servers_only(elems) do
    Enum.filter(elems, fn
      %ServerInfo{} -> true
      %HostInfo{} -> false
    end)
  end
end
