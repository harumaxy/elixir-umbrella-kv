# KvUmbrella

## Umbrella Projects の操作

```sh
mix new . --app kv_umbrella --umbrella

# アプリを作る
# path : apps の中にプロジェクトディレクトリを作るように指定すればわざわざ cd して mix new しなくていい
# --sup : Supervisor を自動的に生成する
mix new apps/kv_server --module KVServer --sup　

```

## apps/ 以下の Mix project の mix.exs

```elixir
defmodule {App}.MixProject do
  def project do
    [
      app: :kv_server,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end
  ...
end
```

mix project 内に `apps` ディレクトリがある状態で mix new すると、アンブレラ構造を検知してプロジェクト構造に4行追加される
(build_path ~ lockfile)
これらは親プロジェクトを参照する

```elixir
  def application do
    [
      extra_applications: [:logger],
      mod: {KVServer.Application, []}
    ]
  end
```
`--sup` フラグを付けたので、自動的に KVServer.Application モジュールの実装が追加され、 mod: [] オプションがあるので
Elixir アプリを実行したら自動で Application.start が実行される (Supervisor プロセスをスタートする)
デフォルトだと children は何も指定されてない

## Don't drink kool aid

Umbrella project はある程度の依存関係・設定の共有を行う
異なる依存、異なる設定が必要になる場合、アンブレラ・プロジェクトで管理する範囲を超えているということになる。

その場合の対処は簡単で、 `apps` 及び アンブレラ・プロジェクトの外にアプリを出して、 build_path, config_path, deps_path, lockfile の設定を直して別プロジェクトにすればいい。
別のGitリポジトリに移して、元のアンブレラに外部依存として追加し直す

Hex.pm のプライベートパッケージとして公開しても良い (組織を作ると、プライベートパッケージをホスティングできる)

# Task & :gen_ctp

Erlang :gen_tcp モジュール
TCPサーバーを作るのに使える