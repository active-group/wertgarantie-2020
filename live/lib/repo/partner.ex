defmodule Live.Repo.Partner do
  @moduledoc """
  Operiert mit der Tabelle "partner" aus Postgres
  """
  import Ecto.Query

  @doc "Wandelt das Datenbankergebnis zu einem Partner-Struct"
  @spec to_partner(list()) :: Live.Domain.Partner.t()
  def to_partner([id, admission_years]) do
    Live.Domain.Partner.make(id, admission_years)
  end

  @doc "Liest einen Partner aus der Datenbank aus"
  @spec by_partner_nr(Live.Domain.Schaden.partner_nr()) :: Live.Domain.Partner.t()
  def by_partner_nr(partner_nr) do
    query =
      from(p in "partner",
        select: [p.partner_nr, p.year_of_admission],
        where: p.partner_nr == ^partner_nr
      )

    Live.Repo.one!(query)
    |> to_partner()
  end
end
