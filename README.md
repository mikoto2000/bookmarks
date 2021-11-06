# Bookmarks

## Build

```sh
elm-format --yes src/Main.elm
elm make --output=dist/bookmarks.js src/Main.elm
```

## Todo

- [x] : ブックマークリスト表示
- [ ] : ブックマークリストファイルを外だし
    - [x] : Http, Json モジュールでファイルを読み込む
    - [ ] : エラー通知
- [ ] : ユーザー毎にブックマークリストファイルを作れるようにする
- [ ] : 見た目改善
