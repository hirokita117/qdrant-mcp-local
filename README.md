# qdrant-mcp-local

ローカル環境でQdrantとMCP-server-qdrantを簡単に立ち上げるためのDocker Compose設定です。

## 概要

このリポジトリは以下のコンポーネントを含んでいます：

1. **Qdrant** - ベクトル検索エンジン
2. **MCP-server-qdrant** - [Model Context Protocol (MCP)](https://modelcontextprotocol.io/introduction)サーバー。Qdrantベクトルデータベースとの連携をサポートします。

## セットアップ方法

### 前提条件

- Docker
- Docker Compose

### 使用方法

1. リポジトリをクローンします：

```bash
git clone https://github.com/hirokita117/qdrant-mcp-local.git
cd qdrant-mcp-local
```

2. Docker Composeを使って環境を起動します：

```bash
docker-compose up -d
```

これにより以下のサービスが起動します：
- Qdrant: http://localhost:6333
- MCP Server: http://localhost:8000

3. 環境を停止するには：

```bash
docker-compose down
```

永続データを完全に削除するには：

```bash
docker-compose down -v
```

## 設定のカスタマイズ

`.env`ファイルを編集することで、環境変数を変更できます。

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
