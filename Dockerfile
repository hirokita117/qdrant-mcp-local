FROM python:3.11-slim

WORKDIR /app

# 必要なパッケージをインストール
RUN apt-get update && apt-get install -y curl && \
    pip install --no-cache-dir pip --upgrade

# uvとmcp-server-qdrantのインストール
RUN pip install --no-cache-dir uv
RUN pip install --no-cache-dir mcp-server-qdrant

# インストールされたコマンドの確認
RUN pip list && \
    which mcp-server-qdrant || echo "mcp-server-qdrant not found in PATH"

# 健全性確認用のデバッグスクリプトを作成
RUN echo "#!/bin/bash\necho 'Starting MCP Server...'\nexec mcp-server-qdrant --transport sse" > /app/start.sh && \
    chmod +x /app/start.sh

# SSE用のポートを公開
EXPOSE 8000

# デバッグスクリプトを使って起動
CMD ["/app/start.sh"]
