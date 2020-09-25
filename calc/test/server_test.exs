defmodule ServerTest do
  use ExUnit.Case
  doctest Server

  def port, do: Application.get_env(:calc, Server)[:port]

  # test "checks the server echo" do
  #   {:ok, socket} =
  #     :gen_tcp.connect(:"127.0.0.1", port(), [:binary, {:packet, 0}, {:active, false}])

  #   :gen_tcp.send(socket, 'Hallo\n')

  #   assert :gen_tcp.recv(socket, 0) == {:ok, "HALLO\n"}
  # end

  test "checks read server" do
    {:ok, socket} =
      :gen_tcp.connect(:"127.0.0.1", port(), [:binary, {:packet, 0}, {:active, false}])

    :gen_tcp.send(socket, 'Hallo\n')
    assert :gen_tcp.recv(socket, 0) == {:ok, "error: couldn't proceed with input 'Hallo'\n"}

    :gen_tcp.send(socket, '5\n')
    assert :gen_tcp.recv(socket, 0) == {:ok, "120\n"}

    :gen_tcp.send(socket, '8\n')
    assert :gen_tcp.recv(socket, 0) == {:ok, "error: not in index\n"}
  end
end
