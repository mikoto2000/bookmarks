#!/bin/bash

npx elm-format --yes src/Main.elm
cp -r ./openapi/dest/src/Api.elm ./openapi/dest/src/Api/ ./src
npx elm make --output=dist/bookmarks.js src/Main.elm
cp -r src/users ./dist

