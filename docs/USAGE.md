# 使用方法

このドキュメントでは、qdrant-mcp-localの詳細な使用方法について説明します。

## 基本的な使用方法

### 1. 事前準備

データ保存用のディレクトリを作成します：

```bash
mkdir -p data
```

### 2. 環境の起動

```bash
docker compose up -d
```

### 3. 環境の確認

Qdrantサーバーが正常に起動しているか確認：

```bash
curl http://localhost:6333/readiness
```

成功すると、`{"status":"ok"}`が返されます。

MCPサーバーの接続を確認：

```bash
curl http://localhost:8000/health
```

### 4. 環境の停止

```bash
docker compose down
```

## 高度な使用方法

### カスタム設定

`.env`ファイルを編集することで、以下の設定をカスタマイズできます：

- `QDRANT_PORT`: Qdrantサーバーのポート番号
- `QDRANT_HTTP_PORT`: QdrantのHTTPポート番号
- `MCP_SERVER_PORT`: MCPサーバーのポート番号
- `COLLECTION_NAME`: Qdrantコレクション名
- `EMBEDDING_MODEL`: 埋め込みモデル

### データの保存場所

Qdrantのデータは`./data`ディレクトリに保存されます。このディレクトリはホスト側に作成され、Dockerコンテナが削除されてもデータは保持されます。

別の場所にデータを保存したい場合は、`docker-compose.yml`ファイルの以下の部分を編集してください：

```yaml
volumes:
  - ./data:/qdrant/storage
```

例えば、絶対パスで指定する場合：

```yaml
volumes:
  - /path/to/your/data:/qdrant/storage
```

## MCPクライアントとの連携

### Claude Desktop

Claude Desktopで使用するには、`claude_desktop_config.json`ファイルに以下の設定を追加します：

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

### Claude Web

Claude Web（ブラウザ版）では現在MCPサーバーの設定はサポートされていません。

### Cursor

Cursorで使用するには、MCPサーバー設定でSSEエンドポイントを指定します：

```
http://localhost:8000/sse
```

## 使用例

### 情報の保存

MCPクライアント（Claude Desktopなど）を使って情報を保存します：

1. MCPツール`qdrant-store`を呼び出し
2. `information`パラメータに保存したい情報を入力
3. 必要に応じて`metadata`パラメータにJSONデータを追加

### 情報の検索

MCPクライアントを使って保存した情報を検索します：

1. MCPツール`qdrant-find`を呼び出し
2. `query`パラメータに検索したい内容を入力

## トラブルシューティング

### コンテナが起動しない

ログを確認：

```bash
docker compose logs
```

### ポートの競合

既に使用中のポートがある場合は、`.env`ファイルで別のポート番号を指定してください。

### データディレクトリのパーミッション問題

Qdrantがデータディレクトリに書き込めない場合、パーミッションを確認して調整してください：

```bash
chmod -R 777 data
```

ただし、本番環境ではより安全なパーミッション設定を検討してください。
