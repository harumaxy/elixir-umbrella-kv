_ = """
# Document test



"""

defmodule KVServer.Command do
  @doc ~S"""
  ~S シギルを使うと、エスケープ文字を無視できる (Doctest の文字列で、エスケープ文字を使う場合に有用)
  Parses the given `line` into a command

  ## Examples (この行は必須じゃない)
  doctestを記述するには、 iex> の行に式を書いたあと、次の行に期待される戻り値を書く
  4スペースインデントをおくのが慣習だが、必須ではない

  ## Examples

    iex> KVServer.Command.parse("CREATE shopping\r\n")
    {:ok, {:create, "shopping"}}

    iex> KVServer.Command.parse("CREATE shopping  \r\n")
    {:ok, {:create, "shopping"}}

    iex> KVServer.Command.parse("PUT shopping milk 1  \r\n")
    {:ok, {:put, "shopping", "milk", "1"}}

    iex> KVServer.Command.parse("GET shopping  milk\r\n")
    {:ok, {:get, "shopping", "milk"}}

    iex> KVServer.Command.parse("DELETE shopping  eggs\r\n")
    {:ok, {:delete, "shopping", "eggs"}}

  Unknown commands or commands with the wrong number of arguments return an error:

      iex> KVServer.Command.parse("UNKNOWN shopping eggs \r\n")
      {:error, :unknown_command}

      iex> KVServer.Command.parse("GET shopping \r\n")
      {:error, :unknown_command}
  """
  def parse(line) do
    case String.split(line) do
      ["CREATE", bucket] -> {:ok, {:create, bucket}}
      ["GET", bucket, key] -> {:ok, {:get, bucket, key}}
      ["PUT", bucket, key, value] -> {:ok, {:put, bucket, key, value}}
      ["DELETE", bucket, key] -> {:ok, {:delete, bucket, key}}
      _ -> {:error, :unknown_command}
    end
  end

  @doc """
  Runs the given command.
  """
  def run(command)

  def run({:create, bucket}) do
    KV.Regis
  end
end
