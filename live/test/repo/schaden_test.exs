defmodule Live.Repo.SchadenTest do
  use ExUnit.Case

  alias Live.Repo

  test "alles abfragen" do
    assert Repo.Schaden.all() ==
             [
               [1, "Bagatelle", 20.0, 1001],
               [2, "Stoßstange sind heutzutage lackiert", 500, 1001],
               [3, "Stoßstangen sind heutzutage lackiert", 400, 1002]
             ]
  end
end
