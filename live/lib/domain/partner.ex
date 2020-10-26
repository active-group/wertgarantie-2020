defmodule Live.Domain.Partner do
  @moduledoc """
  Der Datentyp Partner besteht aus:
  - partner_nr (int): Partner-Nummer der versicherten Person
  - year_of_admission (int): Eintrittsjahr der Partners
  """

  use QuickStruct,
    partner_nr: Live.Domain.Schaden.partner_nr(),
    year_of_admission: integer()

end
