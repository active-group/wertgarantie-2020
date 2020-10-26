defmodule Live.Repo.SchadenTest do
  use ExUnit.Case

  alias Live.Repo

  test "to_schaden" do
    assert Live.Repo.Schaden.to_schaden([2, "Stoßstange sind heutzutage lackiert", 500, 1001]) ==
             Live.Domain.Schaden.make(2, 500, "Stoßstange sind heutzutage lackiert", 1001)
  end

  @tag :with_database
  test "alles abfragen" do
    assert Repo.Schaden.all() ==
             [
              Live.Domain.Schaden.make(1, 20.0, "Bagatelle", 1001),
              Live.Domain.Schaden.make(2, 500, "Stoßstange sind heutzutage lackiert", 1001),
              Live.Domain.Schaden.make(3, 400, "Stoßstangen sind heutzutage lackiert", 1002)
             ]
  end
end
