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

end
