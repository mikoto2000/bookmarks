module Main exposing (main, update, view)

import Browser
import Html exposing (Html, a, button, div, li, p, text, ul)
import Html.Attributes exposing (href, id)
import Http
import Json.Decode exposing (Decoder, field, list, map2, string)
import List
import String


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- 型定義


type alias Model =
    { bookmarks : List Bookmark }


type alias Bookmark =
    { title : String
    , url : String
    }



-- メッセージ定義


type Msg
    = GotBookmarks (Result Http.Error (List Bookmark))



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [], getBookmarks )



-- UPDATE


update msg model =
    case msg of
        GotBookmarks result ->
            case result of
                Ok bookmarks ->
                    ( { model | bookmarks = bookmarks }, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions model =
    Sub.none


view model =
    div []
        [ div []
            [ div [ id "bookmarks" ]
                [ ul []
                    (List.map to_anchor model.bookmarks)
                ]
            ]
        ]


to_anchor bookmark =
    li []
        [ a [ href bookmark.url ] [ text bookmark.title ] ]



-- HTTP


getBookmarks : Cmd Msg
getBookmarks =
    Http.get
        { url = "./users/mikoto2000.json"
        , expect = Http.expectJson GotBookmarks bookmarkListDecoder
        }


bookmarkListDecoder : Decoder (List Bookmark)
bookmarkListDecoder =
    Json.Decode.list bookmarkDecoder


bookmarkDecoder : Decoder Bookmark
bookmarkDecoder =
    map2 Bookmark
        (field "title" string)
        (field "url" string)
