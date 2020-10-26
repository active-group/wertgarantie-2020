defmodule Live.Repo.Schaden do
  @moduledoc """
  Operiert mit der Tabelle "schaden" aus Postgres
  """
  import Ecto.Query

  @doc "Alle Daten auslesen"
  @spec all() :: any()
  def all() do
    # SELECT s.id, s.desc, s.amount, s.partner FROM schaden S WHERE s.id > 0
    query =
      from(s in "schaden",
        select: [s.id, s.desc, s.amount, s.partner],
        where: s.id > 0
      )

    Live.Repo.all(query)
  end
end
