defmodule DnsServer.RegistryProcessTest do
  use ExUnit.Case
  alias DnsServer.LookupProcess
  alias DnsServer.RegistryProcess
  alias DnsServer.Domain.ServerInfo

  describe "put/2" do
    test "puts a new entry properly" do
      server1 = ServerInfo.make(["wikipedia", "org"], nil, nil)

      lookup_name = :put_test_lookup
      LookupProcess.start_link(name: lookup_name)

      state = RegistryProcess.State.make(lookup_name)

      matches_before = LookupProcess.best_matching(:put_test_lookup, "de.wikipedia.org")

      {:noreply, _} = RegistryProcess.handle_cast({:register_child, server1}, state)

      matches = LookupProcess.best_matching(:put_test_lookup, "de.wikipedia.org")
      assert matches_before != matches
      assert matches == [server1]
    end
  end
end
