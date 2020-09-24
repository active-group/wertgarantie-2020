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

  # >>> Server

  defmodule Inc do
    @moduledoc """
    Beinhaltet die Zahl, um die erhöht werden soll
    """
    use QuickStruct, i: integer()
  end

  defmodule Get do
    @moduledoc """
    Beinhaltet die Prozess-ID desjenigen, der die Antwort erhalten soll
    """
    use QuickStruct, sender_pid: pid()
  end

  @doc """
  Ein increment Server speichert eine Zahl und kann zwei Nachrichten erhalten:
  - Inc: Erhöhe um die Zahl i
  - Get: Gebe die Zahl aus

  Der Startwert wird als Argument übergeben.
  """
  @spec inc_loop(integer()) :: any()
  def inc_loop(aktueller_wert) do
    receive do
      %Inc{i: i} ->
        # IO.puts(aktueller_wert + i)
        inc_loop(aktueller_wert + i)

      %Get{sender_pid: sender_pid} ->
        send(sender_pid, aktueller_wert)
        inc_loop(aktueller_wert)
    end
  end

  @doc "Starte den Server"
  @spec start_inc_loop(integer()) :: true
  def start_inc_loop(startwert) do
    pid = spawn(fn -> inc_loop(startwert) end)
    # pid = spwan(ProcessDemo, :inc_loop, [startwert])

    Process.register(pid, :inc_server)
  end

  # <<< Server

  # >>> Client
  @doc "Sende Inc mit i an den Server"
  @spec inc(integer()) :: :ok
  def inc(i) do
    # %Inc{i: zahl}
    send(:inc_server, Inc.make(i))

    :ok
  end

  @doc "Sende Get an Server"
  @spec get() :: integer()
  def get() do
    send(:inc_server, Get.make(self()))

    receive do
      msg -> msg
    end
  end

  # <<< Client
end
