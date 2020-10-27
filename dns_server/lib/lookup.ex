defmodule DnsServer.Lookup do
  alias DnsServer.Domain

  use QuickStruct, entries: [Domain.dns_element()]
  alias __MODULE__

  def init(), do: Lookup.make([])

  # filter the matching namespace from a list
  @spec get_matching_namespaces([String.t()], [Domain.namespaces_t()]) :: [Domain.namespaces_t()]
  defp get_matching_namespaces(uri, namespaces) do
    Enum.filter(namespaces, fn namespace ->
      namespace == uri
    end)
  end

  @spec best_matching_helper([String.t()], [Domain.namespaces_t()]) :: [Domain.namespaces_t()]

  # recursion termination, returns an empty list (no results)
  defp best_matching_helper([], _), do: []

  # recursively searches namespaces by getting less and less precise
  defp best_matching_helper(uri, namespaces) do
    case get_matching_namespaces(uri, namespaces) do
      [] ->
        [_ | rest] = uri
        best_matching_helper(rest, namespaces)

      result ->
        result
    end
  end

  @doc """
  Returns the best matching namespaces. That is, it is preferering more
  precise namespace over general.
  """
  @spec best_matching_2(Domain.uri_t(), [Domain.namespaces_t()]) :: [Domain.namespaces_t()]
  defp best_matching_2(uri, namespaces) do
    uri_list = String.split(uri, ".")
    best_matching_helper(uri_list, namespaces)
  end

  @spec best_matching(Lookup.t(), Domain.uri_t()) :: [Domain.dns_element()]
  def best_matching(%Lookup{entries: entries}, uri) do
  end

  @spec put(DnsServer.Lookup.t(), Domain.dns_element()) :: DnsServer.Lookup.t()
  def put(%Lookup{entries: entries} = lookup, entry) do
    %Lookup{lookup | entries: [entry | entries]}
  end
end
