defmodule Live.Domain.Schaden do
  @moduledoc """
  Der Datentyp Schaden besteht aus:
  - id (int)
  - forecast_amount (float): Prognostizierte Schadenssumme, Reserve
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

  @doc """
  Sortiert eine Liste von Schäden, anhand ihrer Schadenssumme (aufsteigend).

  ## Examples

      iex> Live.Domain.Schaden.sort_along_amount([
      ...>   Live.Domain.Schaden.make(1, 18.0, "", 1),
      ...>   Live.Domain.Schaden.make(2, 10.0, "", 2)
      ...> ])
      [
        Live.Domain.Schaden.make(2, 10.0, "", 2),
        Live.Domain.Schaden.make(1, 18.0, "", 1)
      ]

  """
  @spec sort_along_amount([Schaden.t()]) :: [Schaden.t()]
  def sort_along_amount(schadensliste) do
    Enum.sort_by(schadensliste, fn schaden -> schaden.forecast_amount end)
  end
end
