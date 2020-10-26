defmodule Live.Domain.Risikobewertung do
  @moduledoc """
  Berechnet die Risikobewertung eines Partners

  Der Datentyp besteht aus:
  - Schadenssumme pro Jahr
  """

  use QuickStruct, amount_per_year: float()
  # %Live.Domain.Riskobewertung{amount_per_year: 0.0}

  @doc """
  Berechnet die Risikobewertung eines Partners
  """
  @spec calc(Live.Domain.Schaden.partner_nr()) :: Live.Domain.Risikobewertung.t()
  def calc(partner_nr) do
    aktuelles_jahr = DateTime.utc_now() |> Map.fetch!(:year)

    eintritt_partner =
      Live.Repo.Partner.by_partner_nr(partner_nr)
      |> case do
        [_id, year] -> year
      end

    alle_schäden = Live.Repo.Schaden.all()

    schadenssumme =
      Enum.filter(
        alle_schäden,
        fn [_id, _desc, _amount, p_nr] ->
          p_nr == partner_nr
        end
      )
      |> Enum.map(fn [_id, _desc, amount, _p_nr] -> amount end)
      |> Enum.sum()

    jahre_dabei = max(aktuelles_jahr - eintritt_partner + 1, 1)

    make(schadenssumme / jahre_dabei)
  end

  # Schlecht an dieser Lösung:
  # - Testbar nur mit Datenbank
  # - Logik anderer Domäne findet hier statt
  # - Änderung am Datenbankschema macht unsere Funktion kaputt
end
