defmodule DnsServer.Lookup do
  alias DnsServer.Domain

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
  @spec best_matching(Domain.uri_t(), [Domain.namespaces_t()]) :: [Domain.namespaces_t()]
  def best_matching(uri, namespaces) do
    uri_list = String.split(uri, ".")
    best_matching_helper(uri_list, namespaces)
  end
end
