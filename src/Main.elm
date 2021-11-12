module Main exposing (main, update, view)

import Browser
import Html exposing (Html, a, button, div, li, p, pre, text, ul)
import Html.Attributes exposing (href, id)
import Http exposing (Expect, Metadata)
import Json.Decode exposing (Decoder, field, list, map2, string)
import List
import String


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- 型定義


type alias Model =
    { bookmarks : List Bookmark, infomation : String }


type alias Bookmark =
    { title : String
    , url : String
    }


type GetBookmarksResult
    = BadUrl String
    | Timeout
    | NetworkError
    | BadStatus Metadata
    | BadContents Metadata String



-- メッセージ定義


type Msg
    = GotBookmarks (Result GetBookmarksResult (List Bookmark))



-- INIT


init : () -> ( Model, Cmd Msg )
init _ =
    ( Model [] infomation_loading, getBookmarks )



-- UPDATE


update msg model =
    case msg of
        GotBookmarks result ->
            case result of
                Ok bookmarks ->
                    ( { model | bookmarks = bookmarks, infomation = "" }, Cmd.none )

                Err error ->
                    case error of
                        BadUrl url ->
                            ( { model | infomation = "ブックマークリストファイルのダウンロードに失敗しました。\nBadUrl: " ++ url }, Cmd.none )

                        Timeout ->
                            ( { model | infomation = "ブックマークリストファイルのダウンロードに失敗しました。\nTimeout" }, Cmd.none )

                        NetworkError ->
                            ( { model | infomation = "ブックマークリストファイルのダウンロードに失敗しました。\nNetworkError" }, Cmd.none )

                        BadStatus metadata ->
                            ( { model | infomation = "ブックマークリストファイルのダウンロードに失敗しました。\nURL: " ++ metadata.url ++ "\nStatus: " ++ String.fromInt metadata.statusCode }, Cmd.none )

                        BadContents metadata body ->
                            ( { model | infomation = "ブックマークリストファイルのダウンロードに失敗しました。\n" ++ body }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions model =
    Sub.none


view model =
    div []
        [ div []
            [ pre [ id "infomation" ] [ text model.infomation ]
            , div [ id "bookmarks" ]
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
        , expect = expectBookmarksJson GotBookmarks bookmarkListDecoder
        }


expectBookmarksJson : (Result GetBookmarksResult a -> msg) -> Decoder a -> Expect msg
expectBookmarksJson toMsg decoder =
    Http.expectStringResponse toMsg <|
        \response ->
            case response of
                Http.BadUrl_ url ->
                    Err (BadUrl url)

                Http.Timeout_ ->
                    Err Timeout

                Http.NetworkError_ ->
                    Err NetworkError

                Http.BadStatus_ metadata body ->
                    Err (BadStatus metadata)

                Http.GoodStatus_ metadata body ->
                    case Json.Decode.decodeString decoder body of
                        Ok value ->
                            Ok value

                        Err err ->
                            Err (BadContents metadata (Json.Decode.errorToString err))


bookmarkListDecoder : Decoder (List Bookmark)
bookmarkListDecoder =
    Json.Decode.list bookmarkDecoder


bookmarkDecoder : Decoder Bookmark
bookmarkDecoder =
    map2 Bookmark
        (field "title" string)
        (field "url" string)



-- ユーザー向け通知メッセージ


infomation_loading =
    "ロード中..."


infomation_json_load_error =
    "JSON の読み込みに失敗しました"
