defmodule Live.Domain.Partner do
  @moduledoc """
  Der Datentyp Partner besteht aus:
  - partner_nr (int): Partner-Nummer der versicherten Person
  - year_of_admission (int): Eintrittsjahr der Partners
  """

  use QuickStruct,
    partner_nr: Live.Domain.Schaden.partner_nr(),
    year_of_admission: integer()

  @doc """
  Wie viele Jahre ist ein Partner dabei, mit übergegebenem aktuellem Jahr
  Ist mindestens immer 1.

  ## Examples

      iex> Live.Domain.Partner.admission_years(Live.Domain.Partner.make(99, 2016), 2020)
      5
  """
  @spec admission_years(t(), integer()) :: integer()
  def admission_years(partner, year) do
    max(year - partner.year_of_admission + 1, 1)
  end
end
