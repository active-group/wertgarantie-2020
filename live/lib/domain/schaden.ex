defmodule Live.Domain.Schaden do
  @moduledoc """
  Der Datentyp Schaden besteht aus:
  - id (int)
  - forecast_amount (float): Prognostizierte Schadenssumme, Reserve
  - description (string): Beschreibung des Schadens
  - partner_nr (int): Partner-Nummer der versicherten Person
  """
  require Logger

  @type partner_nr :: integer()

  use QuickStruct,
    id: integer(),
    forecast_amount: float(),
    description: String.t(),
    partner_nr: partner_nr()

  @doc "Bekommt zwei Schäden und liefert den Schaden mit der höheren Schadenssumme zurück"
  @spec with_max_amount(Schaden.t(), Schaden.t()) :: Schaden.t()
  def with_max_amount(first, second) do
    if first.forecast_amount >= second.forecast_amount do
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

  @doc """
  Errechnet die Summe einer Liste an Schäden
  """
  @spec amount_sum([Schaden.t()]) :: float()
  # def amount_sum(_schadensliste) do
  #   0.0
  # end
  def amount_sum(schadensliste) do
    case schadensliste do
      [] -> 0.0
      # [el] -> el.forecast_amount
      # [first, second] -> first.forecast_amount + second.forecast_amount
      [el | rest] -> el.forecast_amount + amount_sum(rest)
    end
  end

  @doc """
  Überprüft ob alle Schäden einer Liste zu einer übergebenen Partner Nummer gehören
  """
  @spec belongs_to_partner?([Schaden.t()], partner_nr()) :: boolean()
  # def belongs_to_partner?(schadensliste, p_nr) do
  #   case schadensliste do
  #     [] -> true
  #     [el | rest] ->
  #       el.partner_nr == p_nr and belongs_to_partner?(rest, p_nr)
  #   end
  # end
  def belongs_to_partner?(schadensliste, p_nr) do
    Enum.all?(schadensliste, fn schaden -> schaden.partner_nr == p_nr end)
    # Enum.all?(schadensliste, &(&1.partner_nr == p_nr))
  end

  @doc """
  Überprüft ob alle Schäden einer Liste zu einer übergebenen Partner Nummer gehören.
  Die Schadensliste darf nicht leer sein, sonst protokolliere eine Warnmeldung
  """
  @spec belongs_to_partner_with_logging?([Schaden.t()], partner_nr()) :: boolean()
  def belongs_to_partner_with_logging?(schadensliste, p_nr) do
    if schadensliste == [] do
      Logger.warn(
        "Called belongt_to_partner? with empty list and partner_nummer '#{p_nr}'"
      )
    end

    belongs_to_partner?(schadensliste, p_nr)
  end
end
