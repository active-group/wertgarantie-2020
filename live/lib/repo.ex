defmodule Live.Repo do
  @moduledoc """
  Unsere Hauptdatenbank
  """
  use Ecto.Repo,
    otp_app: :live,
    adapter: Ecto.Adapters.Postgres
end
