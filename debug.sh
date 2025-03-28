#!/bin/bash

# デバッグ用スクリプト
echo "=== システム情報 ==="
uname -a
docker --version
docker compose version

echo -e "\n=== コンテナステータス確認 ==="
docker compose ps

echo -e "\n=== qdrantコンテナログ ==="
docker compose logs qdrant

echo -e "\n=== mcp-serverコンテナログ ==="
docker compose logs mcp-server

echo -e "\n=== mcp-serverコンテナ内の状態確認 ==="
# コンテナが起動している場合のみ実行
if docker compose ps | grep -q "mcp-server.*Up"; then
  echo "コンテナが起動しています。詳細チェックを実行します..."
  docker compose exec mcp-server pip list
  docker compose exec mcp-server which mcp-server-qdrant || echo "mcp-server-qdrantコマンドが見つかりません"
else
  echo "mcp-serverコンテナが起動していません。詳細チェックはできません。"
  # 起動していなくても直接コマンドを実行してみる
  docker compose run --rm mcp-server pip list
  echo -e "\nインストール済みパッケージ一覧↑"
fi

echo -e "\n=== デバッグ完了 ==="
echo "このファイルの出力をコピーして支援を求める際に共有してください。"
