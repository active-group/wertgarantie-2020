defmodule Live.Repo.Partner do
  @moduledoc """
  Operiert mit der Tabelle "partner" aus Postgres
  """
  import Ecto.Query

  @doc "Liest einen Partner aus der Datenbank aus"
  @spec by_partner_nr(Live.Domain.Schaden.partner_nr()) :: any()
  def by_partner_nr(partner_nr) do
    query =
      from(p in "partner",
        select: [p.partner_nr, p.year_of_admission],
        where: p.partner_nr == ^partner_nr
      )

    Live.Repo.one!(query)
  end
end
