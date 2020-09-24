defmodule Intro do
  @moduledoc """
  Unsere Sammlung an einführenden Beispielen.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Intro.hello()
      :world

  """
  def hello do
    :world
  end

  @doc "Berechnet die Wurzel einer natürlichen Zahl"
  @spec wurzel(pos_integer()) :: float()
  def wurzel(n) do
    :math.sqrt(n)
  end

  @doc "Den Kreisumfang berechnen (zu einem gegebenen Radius, das heißt 2 * Pi * r)"
  @spec umfang(float()) :: float()
  def umfang(radius) do
    2 * :math.pi() * radius
  end

  @doc """
  Überprüfe ob eine Zeichenkette das Wort "do" enthält

  ## Examples

      iex> Intro.contains_do("Hallo")
      false
      iex> Intro.contains_do("Sudo")
      true
      iex> Intro.contains_do("do end concept")
      true

  """
  @spec contains_do(String.t()) :: boolean()
  def contains_do(text) do
    String.contains?(text, "do")
  end

  # Zusammengesetzte Daten

  # Einfacher Key-Value-Struct
  # @enforce_keys [:key, :value]
  # defstruct [:key, :value]
  # @type hans :: %Intro{key: integer(), value: String.t()}
  # def make(var_key, var_value) do
  #   %Intro(key: var_key, value: var_value)
  # end

  # def intro1(), do: %Intro{key: 1, value: "Hallo"} # , do: ... ist abgekürzt für do ... end (nur eine Anweisung möglich)
  # def intro2(), do: %Intro{key: 2, value: "blubb"}

  use QuickStruct, key: integer(), value: String.t()

  def intro1(), do: make(1, "Hallo")
  def intro2(), do: make(2, "blubb")
  def intro3(), do: %Intro{value: "3. Wert", key: 3}

  defmodule Rechnung do
    @moduledoc """
    Rechnungen bestehen aus:
    - einem Empfänger (E-Mailadresse als String)
    - einem Betrag (float)
    - ob die Rechnung bezahlt wurde (boolean, true -> wurde bezahlt)
    """

    use QuickStruct, to: String.t(), amount: float(), is_paid: boolean()

    @doc "Sind alle Rechnungen einer übergebenen Liste bezahlt?"
    @spec all_paid?([Rechnung.t()]) :: boolean()
    def all_paid?(rechnungen) do
      List.foldl(
        rechnungen,
        true,
        fn element, zwischenergebnis ->
          element.is_paid and zwischenergebnis
        end
      )
    end

    # @doc """

    #     iex> Intro.Rechnung.my_fold_function(%Intro.Rechnung{to: "", 200.0, false}, true)
    #     false
    #     iex> Intro.Rechnung.my_fold_function(%Intro.Rechnung{to: "", 200.0, true}, true)
    #     true

    # """
    # @spec my_fold_function(Rechnung.t(), boolean()) :: boolean()
    # def my_fold_function(rechnung, zwischenergebnis) do
    #   rechnung.is_paid and zwischenergebnis
    # end

    @doc "Sind alle Rechnungen einer übergebenen Liste bezahlt?"
    @spec all_paid_go_twice?([Rechnung.t()]) :: boolean()
    # def all_paid_go_twice?(rechnungen) do
    #   result = Enum.map(rechnungen, fn rechnung ->
    #     rechnung.is_paid
    #   end)

    #   Enum.all?(result)
    # end
    def all_paid_go_twice?(rechnungen) do
      Enum.all?(rechnungen, fn rechnung -> rechnung.is_paid end)
    end
  end

  defmodule Lastschrift do
    @moduledoc """
    Eine Lastschrift besteht aus
    - einer deutschen IBAN (String.t)
    - einem Betrag (float)
    - einem Feld ob sie ausgeführt wurde (boolean)
    """

    use QuickStruct, iban: String.t(), amount: float(), is_executed?: boolean()

    @doc "Hat die IBAN einer Lastschrift die richtige Länge (22 Stellen)."
    @spec has_valid_iban?(Lastschrift.t()) :: boolean()
    def has_valid_iban?(lastschrift) do
      String.length(lastschrift.iban) == 22
    end
  end

  @typedoc """
  Zahlungseingänge sind entweder
  - Lastschriften oder
  - Rechnungen
  """
  @type zahlung :: Lastschrift.t() | Rechnung.t()
  @type string_or_regex :: String.t() | Regex.t()

  @doc "Ist das Geld einer Zahlung schon da?"
  @spec got_money?(zahlung()) :: boolean()
  # def got_money?(zahlung) do
  #   case zahlung do
  #     %Lastschrift{is_executed?: result} ->
  #       result # zahlung.is_exectued?
  #     %Rechnung{is_paid: result} ->
  #       result # zahlung.is_paid
  #   end
  # end
  def got_money?(%Lastschrift{is_executed?: result} = _zahlung), do: result
  def got_money?(%Rechnung{is_paid: result} = _zahlung), do: result

  @doc """
  Die Fibonacci-Folge an der Stelle n mit n ab 1.

  f_1 = 1
  f_2 = 1
  f_n = f_n-1 + f_n-2   (für n ab 3)

  ## Examples

      iex> Intro.fibonacci(1)
      1
      iex> Intro.fibonacci(2)
      1
      iex> Intro.fibonacci(3)
      2
      iex> Intro.fibonacci(8)
      21

  """
  @spec fibonacci(pos_integer()) :: pos_integer()
  def fibonacci(1), do: 1
  def fibonacci(2), do: 1
  def fibonacci(n), do: fibonacci(n - 1) + fibonacci(n - 2)

  @doc "Prüfe ob eine übergebene Readme-Datei mehr als 21 Zeilen lang ist"
  @spec readme_long_enough?(String.t(), integer()) :: boolean()
  def readme_long_enough?(file, limit \\ 21) do
    case File.read(file) do
      {:ok, file_content} ->
        String.split(file_content, "\n")
        |> IO.inspect
      {:error, _} -> false
    end


  end
end
