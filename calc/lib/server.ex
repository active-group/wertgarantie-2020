defmodule Server do
  @moduledoc """
  Server ist ein GenServer, der einen TCP-Port öffnet und Nachrichten empfängt.

  Wir möchten zu einer empfangenen Zahl mit der Fakultät antworten.
  Dabei berechnen wir die Fakultät nicht jedes mal neu, sondern der Server
  merkt sich in einer Map, die bisher berechneten Werte.

  Können uns mit Telnet verbinden z. B.:

      telnet localhost 8080
  """
  use GenServer
  require Logger

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end

  @doc "Start the TCP Server"
  def init(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")

    server_pid = self()
    spawn_link(fn -> loop_acceptor(socket, server_pid) end)

    {:ok, {}}
  end

  defp loop_acceptor(socket, server_pid) do
    # Blockiert solange, bis ein Client kommt
    {:ok, client} = :gen_tcp.accept(socket)

    {:ok, child_pid} =
      Task.Supervisor.start_child(Server.MyTaskSupervisor, fn -> serve(client) end)

    # Gebe Kontrolle des Client-Socket an den Unterprozess
    :ok = :gen_tcp.controlling_process(client, child_pid)

    loop_acceptor(socket, server_pid)
  end

  defp serve(client_socket) do
    # Echo: was gelesen wird, wird zurück geschrieben
    read_line(client_socket)
    |> String.upcase()
    |> write_line(client_socket)

    serve(client_socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)

    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
