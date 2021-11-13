# Bookmarks

## Start development

```sh
git clone https://github.com/mikoto2000/bookmarks.git
cd bookmarks
npm install
```


## Build

```sh
npx elm-format --yes src/Main.elm
npx elm make --output=dist/bookmarks.js src/Main.elm
cp -r src/users ./dist
```

## Run application on local

Use [http-party/http-server: a simple zero-configuration command-line http server](https://github.com/http-party/http-server).

```sh
npx http-server -p 8080 ./dist
```

## Edit OpenAPI

Use [swagger-api/swagger-editor: Swagger Editor](https://github.com/swagger-api/swagger-editor).

```sh
docker run -it --rm -p "8081:8080" -v "$(pwd):/work" -e SWAGGER_FILE=/work/openapi/openapi.yaml swaggerapi/swagger-editor
```


## Create JSON schemas

Use [instrumenta/openapi2jsonschema: Convert OpenAPI definitions into JSON schemas for all types in the API](https://github.com/instrumenta/openapi2jsonschema).

```sh
openapi2jsonschema -o ./openapi/schemas ./openapi/openapi.yaml
```


## Todo

- [x] : ブックマークリスト表示
- [x] : ブックマークリストファイルを外だし
    - [x] : Http, Json モジュールでファイルを読み込む
    - [x] : ブックマークリスト取得の API 定義
    - [x] : ブックマークリスト取得のスキーマ定義
    - [x] : エラー通知
        - [x] : エラーだということを表示
        - [x] : エラー内容表示
- [ ] : ユーザー毎にブックマークリストファイルを作れるようにする
    - [x] : とりあえず実装
    - [ ] : OpenAPI Generator での実装に差し替え
    - [ ] : エンドポイントホストを指定できるようにする
- [ ] : 見た目改善
- [ ] : テスト
- [ ] : デプロイスクリプト
- [ ] : リファクタリング
    - [ ] : エラー通知をフォーマット文字列でやる
    - [ ] : テスタブルな関数構成に修正
