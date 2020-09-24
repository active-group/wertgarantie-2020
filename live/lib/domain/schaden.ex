defmodule Live.Domain.Schaden do
  @moduledoc """
  Der Datentyp Schaden besteht aus:
  - id (int)
  - amount (float): Prognostizierte Schadenssumme, Reserve
  - description (string): Beschreibung des Schadens
  - partner_nr (int): Partner-Nummer der versicherten Person
  """

  use QuickStruct,
    id: integer(),
    amount: float(),
    description: String.t(),
    partner_nr: integer()

  @doc "Bekommt zwei Schäden und liefert den Schaden mit der höheren Schadenssumme zurück"
  @spec with_max_amount(Schaden.t(), Schaden.t()) :: Schaden.t()
  def with_max_amount(first, second) do
    if first.amount >= second.amount do
      first
    else
      second
    end
  end
end
