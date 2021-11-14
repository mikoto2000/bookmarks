#!/bin/bash
#
# build.sh
#
# 以下、ビルドとパッケージングを行う。
#
# 1. ビルド
#     1. OpenAPI Generator で生成したソースコードを src へコピー
#         - ※ build.sh 実行前に生成が完了していること
#     2. ソースコードのフォーマット
#     3. ソースコードのビルド
# 2. パッケージング
#     1. html ファイルを dist へコピー
#     2. dist 内のエンドポイントのベースパスを指定されたパスへ置換
#
# ビルドからパッケージングまでやるスクリプトになっているが許して...
#
# Usage:
#     ./build.sh ENDPOINT_BASE_PATH
#
# Example:
#     ./build.sh //mikoto2000.github.io

ENDPOINT_BASE_PATH=${1}

if [ "$ENDPOINT_BASE_PATH" = "" ]; then
    ENDPOINT_BASE_PATH='//localhost:8080'
fi

cp -r ./openapi/dest/src/Api.elm ./openapi/dest/src/Api/ ./src

npx elm-format --yes src/Main.elm
npx elm make --output=dist/bookmarks.js src/Main.elm

cp -r src/index.html src/users ./dist
sed -i -e "s#'//localhost:8080'#'${ENDPOINT_BASE_PATH}'#" ./dist/index.html

