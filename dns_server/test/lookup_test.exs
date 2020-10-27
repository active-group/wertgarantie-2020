defmodule DnsServer.LookupTest do
  use ExUnit.Case
  alias DnsServer.Lookup

  describe "best_matching/2" do
    test "returns an empty list upon empty namespaces" do
      assert Lookup.best_matching("de.wikipedia.org", []) == []
    end

    test "returns slightly matching namespace" do
      assert Lookup.best_matching("de.wikipedia.org", [
               ["wikipedia", "org"],
               ["wikipedia", "com"],
               ["net"]
             ]) == [["wikipedia", "org"]]
    end

    test "returns more precise namespace over general" do
      assert Lookup.best_matching(
               "de.wikipedia.org",
               [["wikipedia", "org"], ["org"]]
             ) == [["wikipedia", "org"]]
    end

    test "returns multiple matches" do
      assert Lookup.best_matching(
               "de.wikipedia.org",
               [["org"], ["org"]]
             ) == [["org"], ["org"]]
    end
  end
end
