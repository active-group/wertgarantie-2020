defmodule Live.Domain.PartnerTest do
  use ExUnit.Case

  doctest Live.Domain.Partner

  alias Live.Domain.Partner

  test "admission years of a partner" do
    assert Partner.admission_years(Partner.make(99, 2016), 2020) ==
             5
  end
end
