defmodule DnsServer.Lookup do
  alias DnsServer.Domain
  alias DnsServer.Domain.ServerInfo
  alias DnsServer.Domain.HostInfo

  use QuickStruct, entries: [Domain.dns_element()]
  alias __MODULE__

  def init(), do: Lookup.make([])

  # filter the matching namespace from a list
  @spec get_matching_namespaces([String.t()], [Domain.dns_element()]) :: [Domain.dns_element()]
  defp get_matching_namespaces(uri, entries) do
    Enum.filter(entries, fn
      %HostInfo{} = host -> HostInfo.matches_namespace?(host, uri)
      %ServerInfo{} = server -> ServerInfo.matches_namespace?(server, uri)
    end)
  end

  @spec best_matching_helper([String.t()], [Domain.dns_element()]) :: [Domain.dns_element()]

  # recursion termination, returns an empty list (no results)
  defp best_matching_helper([], _), do: []

  # recursively searches namespaces by getting less and less precise
  defp best_matching_helper(uri, entries) do
    case get_matching_namespaces(uri, entries) do
      [] ->
        [_ | rest] = uri
        best_matching_helper(rest, entries)

      result ->
        result
    end
  end

  @spec best_matching(Lookup.t(), Domain.uri_t()) :: [Domain.dns_element()]
  def best_matching(%Lookup{entries: entries}, uri) do
    uri_list = String.split(uri, ".")
    best_matching_helper(uri_list, entries)
  end

  @spec put(DnsServer.Lookup.t(), Domain.dns_element()) :: DnsServer.Lookup.t()
  def put(%Lookup{entries: entries} = lookup, entry) do
    %Lookup{lookup | entries: [entry | entries]}
  end

  def remove_server_by_name(%Lookup{entries: entries} = lookup, name) do
    next_entries =
      Enum.filter(entries, fn
        %ServerInfo{name: ^name} -> false
        _ -> true
      end)

    %Lookup{lookup | entries: next_entries}
  end
end
