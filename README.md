# qdrant-mcp-local

ローカル環境でQdrantとMCP-server-qdrantを簡単に立ち上げるためのDocker Compose設定です。

## 概要

このリポジトリは以下のコンポーネントを含んでいます：

1. **Qdrant** - ベクトル検索エンジン
2. **MCP-server-qdrant** - [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction)サーバー。Qdrantベクトルデータベースとの連携をサポートします。

## セットアップ方法

### 前提条件

- Docker
- Docker Compose V2 (現在のDockerには通常組み込まれています)

### 使用方法

1. リポジトリをクローンします：

```bash
git clone https://github.com/hirokita117/qdrant-mcp-local.git
cd qdrant-mcp-local
```

2. データ保存用のディレクトリを作成します：

```bash
mkdir -p data
```

3. Docker Composeを使って環境を起動します（初回はビルドに少し時間がかかります）：

```bash
docker compose up -d
```

これにより以下のサービスが起動します：
- Qdrant: http://localhost:6333
- MCP Server: http://localhost:8000

4. 環境を停止するには：

```bash
docker compose down
```

Qdrantのデータは`./data`ディレクトリに保存されるため、コンテナを停止しても情報は保持されます。

## 設定のカスタマイズ

`.env`ファイルを編集することで、環境変数を変更できます。

## トラブルシューティング

### コンテナが起動しない場合

1. **デバッグスクリプトを実行**:

```bash
chmod +x debug.sh
./debug.sh
```

このスクリプトにより、環境の詳細情報とエラーの詳細が表示されます。

2. **手動でログを確認**:

```bash
docker compose logs mcp-server
```

3. **コンテナ再構築**:

環境を完全に再構築するには：

```bash
docker compose down
docker compose build --no-cache
docker compose up -d
```

4. **一般的な問題と解決策**:

- **ポート競合**: 6333または8000ポートが既に使用されている場合は、`.env`ファイルで別のポートを指定してください。
- **ディスク容量**: Docker用のディスク容量が不足していないか確認してください。
- **Dockerデーモン**: Dockerデーモンが正常に動作しているか確認してください。

詳細なトラブルシューティングについては、[docs/USAGE.md](docs/USAGE.md)を参照してください。

## 使用例

### MCPサーバーのエンドポイント

- MCP SSEエンドポイント: `http://localhost:8000/sse`

### Claude Desktopでの設定例

Claude Desktopで使用する場合、`claude_desktop_config.json`に以下を追加します：

```json
{
  "mcpServers": {
    "qdrant": {
      "command": "curl",
      "args": ["-N", "http://localhost:8000/sse"],
      "transport": "sse"
    }
  }
}
```

### Cursorでの設定例

Cursorで使用する場合、MCPサーバー設定で以下のURLを指定します：

```
http://localhost:8000/sse
```

## ライセンス

このプロジェクトは元のQdrantとMCP-server-qdrantのライセンスに準拠します。
