module Main exposing (main, update, view)

import Browser
import Html exposing (Html, button, div, p, text)


main =
    Browser.sandbox { init = 0, update = update, view = view }


update msg model =
    model


view model =
    div [] [ p [] [ text "Hello, World!" ] ]
