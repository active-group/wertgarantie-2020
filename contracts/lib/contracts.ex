defmodule Contracts do
  @moduledoc """
  Zero Coupon Bond
  Ich erhalte zu einem bestimmten Zeitpunkt in der Zukunft eine Menge von X

  def zcb(100, :EUR, ~N[2020-12-31 01:00:00])
  """

  @type amount_t :: float()
  @type currency_t ::
          :EUR | :USD

  @type date_t :: NaiveDateTime.t()

  defmodule Zero do
    use QuickStruct
  end

  @spec zero() :: contract_t()
  def zero(), do: Zero.make()

  defmodule One do
    use QuickStruct, currency: Contracts.currency_t()
  end

  @spec one(currency_t) :: One.t()
  def one(currency), do: One.make(currency)

  defmodule Scale do
    use QuickStruct, contract: Contracts.contract_t(), amount: Contracts.amount_t()
  end

  @spec scale(contract_t(), amount_t()) :: contract_t()
  def scale(%Zero{}, _amount), do: zero()
  def scale(contract, amount), do: Scale.make(contract, amount)

  defmodule At do
    use QuickStruct, contract: Contracts.contract_t(), date: NaiveDateTime.t()
  end

  @spec at(contract_t(), NaiveDateTime.t()) :: contract_t()
  def at(%Zero{}, _datetime), do: zero()
  def at(contract, datetime), do: At.make(contract, datetime)

  @spec zcb(amount_t(), currency_t(), NaiveDateTime.t()) :: contract_t()
  def zcb(amount, currency, datetime) do
    one(currency)
    |> scale(amount)
    |> at(datetime)
  end

  defmodule Give do
    use QuickStruct, contract: Contracts.contract_t()
  end

  @spec give(contract_t()) :: contract_t()
  def give(%Zero{}, _datetime), do: zero()
  def give(contract), do: Give.make(contract)

  defmodule And do
    use QuickStruct, contract1: Contracts.contract_t(), contract2: Contracts.contract_t()
  end

  @spec und(contract_t(), contract_t()) :: contract_t()
  def und(%Zero{}, contract2), do: contract2
  def und(contract1, %Zero{}), do: contract1
  def und(contract1, contract2), do: And.make(contract1, contract2)

  @type contract_t :: One.t() | Scale.t() | At.t() | And.t() | Give.t() | Zero.t()

  # Ich erhalte zu einem bestimmten Zeitpunkt in der Zukunft eine Menge von X
  # Und du erhältst von mir zu einem bestimmten Zeitpunkt in der Zukunft eine Menge von Y

  @spec and_give(contract_t(), contract_t()) :: contract_t()
  def and_give(contract1, contract2) do
    und(contract1, give(contract2))
  end

  @spec der_vertrag(
          amount_t(),
          currency_t(),
          NaiveDateTime.t(),
          amount_t(),
          currency_t(),
          NaiveDateTime.t()
        ) :: contract_t()
  def der_vertrag(amount1, currency1, date1, amount2, currency2, date2) do
    and_give(
      zcb(amount1, currency1, date1),
      zcb(amount2, currency2, date2)
    )
  end
end
