defmodule DnsServer.LookupTest do
  use ExUnit.Case
  alias DnsServer.Lookup
  alias DnsServer.Domain.ServerInfo
  alias DnsServer.Domain.HostInfo

  describe "best_matching/2" do
    test "returns an empty list upon empty namespaces" do
      lookup = Lookup.init()

      assert Lookup.best_matching(lookup, "de.wikipedia.org") == []
    end

    test "returns slightly matching namespace" do
      server1 = ServerInfo.make(["wikipedia", "org"], nil, nil)
      server2 = ServerInfo.make(["wikipedia", "com"], nil, nil)
      server3 = ServerInfo.make(["net"], nil, nil)

      lookup =
        Lookup.init()
        |> Lookup.put(server1)
        |> Lookup.put(server2)
        |> Lookup.put(server3)

      assert Lookup.best_matching(lookup, "de.wikipedia.org") == [server1]
    end

    test "returns more precise namespace over general" do
      server1 = ServerInfo.make(["wikipedia", "org"], nil, nil)
      server2 = ServerInfo.make(["org"], nil, nil)

      lookup =
        Lookup.init()
        |> Lookup.put(server1)
        |> Lookup.put(server2)

      assert Lookup.best_matching(
               lookup,
               "de.wikipedia.org",
             ) == [server1]
    end

    test "returns multiple matches" do

      server1 = ServerInfo.make(["org"], nil, nil)
      server2 = ServerInfo.make(["org"], nil, nil)

      lookup =
        Lookup.init()
        |> Lookup.put(server1)
        |> Lookup.put(server2)

      assert Lookup.best_matching(
               lookup, "de.wikipedia.org"
             ) == [server1, server2]
    end

    test "lookup returns hosts, too" describe "" do
      server1 = ServerInfo.make(["wikipedia", "org"], nil, nil)
      host1 = HostInfo.make(["wikipedia", "org"], nil, nil)

      lookup =
        Lookup.init()
        |> Lookup.put(server1)
        |> Lookup.put(host1)

      assert Lookup.best_matching(
        lookup, "de.wikipedia.org"
      ) == [server1, host1]
    end
  end
end
