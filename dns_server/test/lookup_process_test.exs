defmodule DnsServer.LookupProcessTest do
  use ExUnit.Case

  alias DnsServer.Lookup
  alias DnsServer.LookupProcess
  alias DnsServer.Domain.ServerInfo

  describe "handle_call/3" do
    test "returns the best matching" do
      server1 = ServerInfo.make(["wikipedia", "org"], nil, nil)

      lookup =
        Lookup.init()
        |> Lookup.put(server1)

      {:reply, matches, state} =
        LookupProcess.handle_call({:best_matching, "de.wikipedia.org"}, nil, lookup)

      assert state == lookup
      assert matches == [server1]
    end
  end
end
