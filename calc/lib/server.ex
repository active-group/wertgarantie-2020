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

  use QuickStruct, factorials: map() #, numbers_to_be_calculated: map()

  @spec start_factorials() :: map()
  def start_factorials() do
    # %Server{factorials: %{0 => 1, ...}}
    Server.make(%{0 => 0, 1 => 1, 2 => 2, 3 => 6, 4 => 24, 5 => 120})
  end


  defmodule Read do
    @moduledoc """
    Antworte mit der Fakultät von "n" an den "reply_to"-Socket.
    """
    use QuickStruct, n: integer(), reply_to: :gen_tcp.socket()
  end

  def start_link(port) do
    GenServer.start_link(__MODULE__, port, name: __MODULE__)
  end

  @impl true
  @doc "Start the TCP Server"
  def init(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")

    server_pid = self()
    spawn_link(fn -> loop_acceptor(socket, server_pid) end)

    {:ok, start_factorials()}
  end

  # Empfängt Verbindungen zu Klienten und startet für jede davon einen Prozess
  defp loop_acceptor(socket, server_pid) do
    # Blockiert solange, bis ein Client kommt
    {:ok, client} = :gen_tcp.accept(socket)
    Logger.info("Client #{inspect(client)} connected.")

    {:ok, child_pid} =
      Task.Supervisor.start_child(Server.MyTaskSupervisor, fn -> serve(client) end)

    # Gebe Kontrolle des Client-Socket an den Unterprozess
    :ok = :gen_tcp.controlling_process(client, child_pid)

    loop_acceptor(socket, server_pid)
  end

  # Empfängt die Nachrichten innerhalb einer Verbindung zu einem Klienten und verarbeitet diese
  defp serve(client_socket) do
    # Echo: was gelesen wird, wird zurück geschrieben
    # read_line(client_socket)
    # |> String.upcase()
    # |> write_line(client_socket)

    case :gen_tcp.recv(client_socket, 0) do
      {:ok, data} ->
        parse_message(data, client_socket)
        serve(client_socket)
      {:error, :closed} ->
        Logger.info("Client #{inspect(client_socket)} disconnected.")
    end
  end

  # Wenn eine Nachricht gelesen wurde, versuche sie zu verstehen und verarbeite diese
  defp parse_message(data, client_socket) do
    trim_and_integer(data)
    |> case do
      {:ok, int} ->
        # %Read{n: int, reply_to: client_socket}
        GenServer.cast(__MODULE__, Read.make(int, client_socket))

      {:error, text} ->
        write_line("error: couldn't proceed with input '#{text}'\n", client_socket)
    end
  end

  # defp read_line(socket) do
  #   {:ok, data} = :gen_tcp.recv(socket, 0)

  #   data
  # end

  defp write_line(line, socket) do
    Logger.info("Replied to #{inspect(socket)} with: #{line}")
    :gen_tcp.send(socket, line)
  end

  @impl true
  def handle_cast(%Read{n: n, reply_to: reply_to}, %Server{} = state) do
    case Map.fetch(state.factorials, n) do
      {:ok, result} ->
        write_line("#{result}\n", reply_to)
      :error ->
        write_line("error: not in index\n", reply_to)
    end

    {:noreply, state}
  end

  @doc ~S"""
  Trimme den Text und schau ob es eine Zahl ist.
  Gebe dann {:ok, zahl} zurück, andernfalls {:error, trim_input}.

      iex> Server.trim_and_integer("80\r\n")
      {:ok, 80}
      iex> Server.trim_and_integer("Hallo          \r\n")
      {:error, "Hallo"}

  """
  @spec trim_and_integer(String.t()) :: {:ok, integer()} | {:error, String.t()}
  def trim_and_integer(text) do
    trim = String.trim(text)

    case Integer.parse(trim) do
      :error -> {:error, trim}
      {int, _binary} -> {:ok, int}
    end
  end
end
