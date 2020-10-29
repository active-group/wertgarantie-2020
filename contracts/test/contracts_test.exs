defmodule ContractsTest do
  use ExUnit.Case
  doctest Contracts

  test "greets the world" do
    assert Contracts.hello() == :world
  end
end
