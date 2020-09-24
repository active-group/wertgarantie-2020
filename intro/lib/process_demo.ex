defmodule ProcessDemo do
  @moduledoc """
  Spielerei mnit Prozessen
  """

  @doc "Echo Prozess"
  @spec echo() :: nil
  def echo() do
    receive do
      :terminate ->
        nil

      msg ->
        IO.puts("Deine Nachricht war: #{msg}")
        echo()
    end
  end

  # def aufwendige_berechnung(n) do
  #   Process.sleep(2000)
  #   IO.puts("Fertig mit Rechnen")
  #   n * n
  # end

  # def schreibe_in_datenbank_danach(n) do
  #   IO.puts("Schreibe in Datenbank")
  #   IO.puts("Ergebnis ist #{n}")
  # end

  # def schreibe_in_datenbank(func) do
  #   IO.puts("Schreibe in Datenbank")
  #   n = func.()
  #   IO.puts("Ergebnis ist #{n}")
  # end
end
