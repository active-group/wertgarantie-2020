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
  # @type t :: %Intro{key: integer(), value: String.t()}
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

    def rechnung1(), do: make("info@example.com", 200.0, false)
    def rechnung2(), do: make("tim@example.com", -10.0, true)
    def rechnung3, do: make("kaan@example.com", 10.0, false)
    def rechnung4(), do: make("chef@example.com", 2000.0, true)
  end
end
