# KvUmbrella

## Umbrella Projects の操作

```sh
mix new . --app kv_umbrella --umbrella

# アプリを作る
# path : apps の中にプロジェクトディレクトリを作るように指定すればわざわざ cd して mix new しなくていい
# --sup : Supervisor を自動的に生成する
mix new apps/kv_server --module KVServer --sup　

```