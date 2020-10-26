defmodule Live.Repo.PartnerTest do
  use ExUnit.Case

  alias Live.Repo

  test "to_partner" do
    assert Live.Repo.Partner.to_partner([99, 2016]) ==
             Live.Domain.Partner.make(99, 2016)
  end

  @tag :with_database
  test "partner 99 abfragen" do
    assert Repo.Partner.by_partner_nr(99) == Live.Domain.Partner.make(99, 2016)
  end
end
