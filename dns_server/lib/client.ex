defmodule DnsServer.Client do
  @type node_t :: any()
  @type uri_t :: String.t()
  @type address_t :: String.t()
  @type find_fn_return_type ::
          {:ok, address_t()} | {:ok, :retry_at, node_t()} | {:error, :not_found}

  @type find_fn_t :: (node_t() -> find_fn_return_type())

  require Logger

  defp resolve_helper(nodes, url, api_find_fn) do
    Enum.reduce(nodes, nil, fn node, result ->
      Logger.info("asking #{inspect(node.name)} (#{inspect(node.namespace)})")

      if result do
        result
      else
        ret =
          case api_find_fn.(node, url) do
            {:ok, :retry_at, nodes} -> resolve_helper(nodes, url, api_find_fn)
            other -> other
          end

        case ret do
          {:ok, something} -> {:ok, something}
          _something_else -> nil
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
    resolve_helper([node], url, api_find_fn)
  end
end
