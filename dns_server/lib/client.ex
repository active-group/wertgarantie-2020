defmodule DnsServer.Client do
  alias DnsServer.Domain
  alias DnsServer.Domain.HostInfo

  @type node_t :: any()
  @type uri_t :: Domain.uri_t()
  @type address_t :: Domain.address_t()
  @type find_fn_return_type ::
          {:ok, address_t()} | {:ok, :retry_at, node_t()} | {:error, :not_found}

  @type find_fn_t :: (node_t() -> find_fn_return_type())

  require Logger

  defp resolve_helper(nodes, url, api_find_fn) do
    Enum.reduce(nodes, nil, fn node, result ->
      Logger.info("asking (#{inspect(node.namespace)})")

      if result do
        result
      else
        case api_find_fn.(node, url) do
          {:ok, :retry_at, nodes} -> resolve_helper(nodes, url, api_find_fn)
          {:ok, something} -> something
          {:error, :not_found} -> nil
        end
      end
    end)
  end

  @doc """
  Takes a node, that is, any representation identifying a node, a URI and a
  find function, and returns an address that belongs to the URI or an not found error.
  """
  @spec resolve(any(), uri_t(), find_fn_t()) :: {:ok, address_t()} | {:error, :not_found}
  def resolve(node, url, api_find_fn) do
    case resolve_helper([node], url, api_find_fn) do
      %HostInfo{address: address} -> {:ok, address}
      _ -> :not_found
    end
  end
end
