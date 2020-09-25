defmodule ServerTest do
  use ExUnit.Case

  def port, do: Application.get_env(:calc, Server)[:port]

  test "checks the server echo" do
    {:ok, socket} =
      :gen_tcp.connect(:"127.0.0.1", port(), [:binary, {:packet, 0}, {:active, false}])

    :gen_tcp.send(socket, 'Hallo\n')

    assert :gen_tcp.recv(socket, 0) == {:ok, "HALLO\n"}
  end
end
