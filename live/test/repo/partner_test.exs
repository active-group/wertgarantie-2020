defmodule Live.Repo.PartnerTest do
  use ExUnit.Case

  alias Live.Repo

  test "partner 99 abfragen" do
    assert Repo.Partner.by_partner_nr(99) == [99, 2016]
  end
end
