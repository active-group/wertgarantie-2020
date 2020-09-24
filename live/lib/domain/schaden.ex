defmodule Live.Domain.Schaden
  @moduledoc """
  Der Datentyp Schaden besteht aus:
  - id (int)
  - amount (float): Prognostizierte Schadenssumme, Reserve
  - description (string): Beschreibung des Schadens
  - partner_nr (int): Partner-Nummer der versicherten Person
  """

  # TODO Strcut

  @doc "Bekommt zwei Schäden und liefert den Schaden mit der höheren Schadenssumme zurück"
  @spec with_max_amount(..., ...) :: ...
  def with_max_amount(..., ...) do

  end
end
