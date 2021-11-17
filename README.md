# Bookmarks

## Start development

```sh
git clone https://github.com/mikoto2000/bookmarks.git
cd bookmarks
npm install
```


## Build

### Generate REST Client

```sh
docker run -it --rm -v "$(pwd):/local" openapitools/openapi-generator-cli generate -i /local/openapi/openapi.yaml -g elm -o /local/openapi/dest
```

### Copy REST Client and build application

#### For development

エンドポイントのベースパスを `//localhost:8080` としてビルドする。

```sh
docker run -it --rm -v "$(pwd):/work" --workdir "/work" node:17 npm run build
```

#### For production example

`npm run build` の第一引数に、エンドポイントのベースパスを設定する。

```sh
docker run -it --rm -v "$(pwd):/work" --workdir "/work" node:17 npm run build -- //mikoto2000.github.io
```

## Test

```sh
docker run -it --rm -v "$(pwd):/work" --workdir "/work" node:17 npm run test
```


## Run application on local

Use [http-party/http-server: a simple zero-configuration command-line http server](https://github.com/http-party/http-server).

```sh
docker run -it --rm -v "$(pwd):/work" --workdir "/work" -p "8080:8080" node:17 npm run run -- -p 8080
```

## Edit OpenAPI

Use [swagger-api/swagger-editor: Swagger Editor](https://github.com/swagger-api/swagger-editor).

```sh
docker run -it --rm -p "8081:8080" -v "$(pwd):/work" -e SWAGGER_FILE=/work/openapi/openapi.yaml swaggerapi/swagger-editor
```


## Create JSON schemas

Use [instrumenta/openapi2jsonschema: Convert OpenAPI definitions into JSON schemas for all types in the API](https://github.com/instrumenta/openapi2jsonschema).

```sh
docker run -it --rm -v "$(pwd):/work" --workdir "/work" mikoto2000/openapi2jsonschema -o ./openapi/schemas ./openapi/openapi.yaml
```


## Todo

- [x] : ブックマークリスト表示
- [x] : ブックマークリストファイルを外だし
    - [x] : Http, Json モジュールでファイルを読み込む
    - [x] : ブックマークリスト取得の API 定義
    - [x] : ブックマークリスト取得のスキーマ定義
    - [ ] : エラー通知
        - [x] : エラーだということを表示
        - [ ] : エラー内容表示(対象リソースの URL を表示)
- [x] : ユーザー毎にブックマークリストファイルを作れるようにする
    - [x] : とりあえず実装
    - [x] : OpenAPI Generator での実装に差し替え
    - [x] : エンドポイントホストを指定できるようにする
- [ ] : 見た目改善
- [ ] : テスト
    - [x] : extractUserFromUrlString
- [x] : openapi2jsonschema を Docker コンテナ化
- [x] : ビルドスクリプト
- [ ] : デプロイスクリプト
- [ ] : リファクタリング
    - [ ] : エラー通知をフォーマット文字列でやる
    - [ ] : テスタブルな関数構成に修正
