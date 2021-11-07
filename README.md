# Bookmarks

## Build

```sh
elm-format --yes src/Main.elm
elm make --output=dist/bookmarks.js src/Main.elm
```

## Run application on local

Use [http-party/http-server: a simple zero-configuration command-line http server](https://github.com/http-party/http-server).

```sh
http-server -p 8080 ./dist
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
- [ ] : ブックマークリストファイルを外だし
    - [x] : Http, Json モジュールでファイルを読み込む
    - [x] : ブックマークリスト取得の API 定義
    - [x] : ブックマークリスト取得のスキーマ定義
    - [ ] : エラー通知
- [ ] : ユーザー毎にブックマークリストファイルを作れるようにする
- [ ] : 見た目改善
