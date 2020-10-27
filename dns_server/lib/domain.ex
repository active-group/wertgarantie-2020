defmodule DnsServer.Domain do
  @type uri_t :: String.t()
  @type zone_t :: String.t()
  @type namespaces_t :: [zone_t()]
end
