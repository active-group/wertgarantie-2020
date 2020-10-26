defmodule Live.Repo.Schaden do
  @moduledoc """
  Operiert mit der Tabelle "schaden" aus Postgres
  """
  import Ecto.Query

  @doc "Wandelt das Datenbankergebnis zu einem Schaden-Struct"
  @spec to_schaden(list()) :: Live.Domain.Schaden.t()
  def to_schaden([id, desc, amount, partner_nr]) do
    Live.Domain.Schaden.make(id, amount, desc, partner_nr)
  end

  @doc "Alle Daten auslesen"
  @spec all() :: list(Live.Domain.Schaden.t())
  def all() do
    # SELECT s.id, s.desc, s.amount, s.partner FROM schaden S WHERE s.id > 0
    query =
      from(s in "schaden",
        select: [s.id, s.desc, s.amount, s.partner],
        where: s.id > 0
      )

    Live.Repo.all(query)
    |> Enum.map(&to_schaden/1)
  end
end
