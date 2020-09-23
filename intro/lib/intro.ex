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
    2 * :math.pi * radius
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
  defstruct [:key, :value]
  @type t2 :: %Intro{key: integer(), value: String.t}


  @spec intro1 :: Intro.t()
  def intro1 do
    %Intro{key: 1, value: "Hallo"}


  end

end
