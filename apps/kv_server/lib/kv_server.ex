# Task.start_link(fn -> KVServer.accept(port) end) で起動される
# Task プロセスは、デフォルトで restart: :temporary がオプションになっており、死んでも Supervisor により再起動されない
# ただし、 acceptor プロセスでは再起動したい

defmodule KVServer do
  require Logger

  def accept(port) do
    {:ok, socket} =
      :gen_tcp.listen(port, [:binary, packet: :line, active: false, reuseaddr: true])

    Logger.info("Accepting connections on port #{port}")
    loop_acceptor(socket)
  end

  defp loop_acceptor(socket) do
    # socket 接続が有るまでプロセスブロック
    {:ok, client} = :gen_tcp.accept(socket)

    # 来たら、非同期タスクを起動。 Task.Supervisor で監視スタートするので、serve Task が死んでもこのプロセスは死なない
    {:ok, pid} = Task.Supervisor.start_child(KVServer.TaskSupervisor, fn -> serve(client) end)
    :ok = :gen_tcp.controlling_process(client, pid)
    # 次のループに入って、また接続待ち
    loop_acceptor(socket)
  end

  defp serve(socket) do
    socket |> read_line() |> write_line(socket)

    serve(socket)
  end

  defp read_line(socket) do
    {:ok, data} = :gen_tcp.recv(socket, 0)
    data
  end

  defp write_line(line, socket) do
    :gen_tcp.send(socket, line)
  end
end
