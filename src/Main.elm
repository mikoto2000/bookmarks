module Main exposing (main, update, view)

import Api
import Api.Data exposing (Bookmark)
import Api.Request.Bookmarks
import Browser
import Html exposing (Html, a, button, div, li, p, pre, text, ul)
import Html.Attributes exposing (href, id)
import Http exposing (Expect, Metadata)
import Json.Decode exposing (Decoder, field, list, map2)
import List
import String
import Url
import Url.Parser exposing ((<?>), parse, query)
import Url.Parser.Query as Query


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- 型定義


type alias Model =
    { user : String, bookmarks : List Bookmark, infomation : String }



-- メッセージ定義


type Msg
    = GotBookmarks (Result Http.Error (List Bookmark))



-- INIT


init : String -> ( Model, Cmd Msg )
init url =
    let
        user =
            extractUserFromUrlString url
    in
    ( Model user [] infomation_loading
    , getBookmarksIfPresentsUser user
    )


getBookmarksIfPresentsUser : String -> Cmd Msg
getBookmarksIfPresentsUser user =
    case user of
        "" ->
            Cmd.none

        default ->
            getBookmarks user



-- UPDATE


update msg model =
    case msg of
        GotBookmarks result ->
            case result of
                Ok bookmarks ->
                    ( { model | bookmarks = bookmarks, infomation = "" }, Cmd.none )

                Err error ->
                    case error of
                        Http.BadUrl url ->
                            ( { model | infomation = "ブックマークリストファイルのダウンロードに失敗しました。\nBadUrl: " ++ url }, Cmd.none )

                        Http.Timeout ->
                            ( { model | infomation = "ブックマークリストファイルのダウンロードに失敗しました。\nTimeout" }, Cmd.none )

                        Http.NetworkError ->
                            ( { model | infomation = "ブックマークリストファイルのダウンロードに失敗しました。\nNetworkError" }, Cmd.none )

                        Http.BadStatus code ->
                            ( { model | infomation = "ブックマークリストファイルのダウンロードに失敗しました。\nPath: ./users/" ++ model.user ++ "\nStatus: " ++ String.fromInt code }, Cmd.none )

                        Http.BadBody body ->
                            ( { model | infomation = "ブックマークリストファイルのダウンロードに失敗しました。\nPath: ./users/" ++ model.user ++ "\n" ++ body }, Cmd.none )



-- SUBSCRIPTIONS


subscriptions model =
    Sub.none


view model =
    let
        infomation =
            if model.user == "" then
                "ユーザーが指定されていません。クエリ文字列でユーザーを指定してください。\n例： user=mikoto2000"

            else
                model.infomation
    in
    div []
        [ div []
            [ pre [ id "infomation" ] [ text infomation ]
            , div [ id "bookmarks" ]
                [ ul []
                    (List.map to_anchor model.bookmarks)
                ]
            ]
        ]


to_anchor bookmark =
    li []
        [ a [ href bookmark.url ] [ text (Maybe.withDefault bookmark.url bookmark.title) ] ]



-- Query


{-| URL 文字列からユーザー名を抽出する。
-}
extractUserFromUrlString : String -> String
extractUserFromUrlString url =
    Url.fromString url
        |> normalizePath
        |> Maybe.andThen (parse (query queryParser))
        |> extractUserFromParseResult


{-| クエリ文字列取得時に、パスに関係なくパースできるようにするためのハックを行う。

    See: <https://github.com/elm/url/issues/17#issuecomment-503630042>

-}
normalizePath : Maybe Url.Url -> Maybe Url.Url
normalizePath url =
    case url of
        Nothing ->
            Nothing

        Just e ->
            Maybe.Just { e | path = "" }


{-| クエリ文字列から `user` パラメーターを抽出するパーサー。
-}
queryParser : Query.Parser (Maybe String)
queryParser =
    Query.string "user"


{-| クエリ文字列のパース結果からユーザー名を抽出する。
-}
extractUserFromParseResult : Maybe (Maybe String) -> String
extractUserFromParseResult parseResult =
    case parseResult of
        Nothing ->
            ""

        Just userResult ->
            case userResult of
                Nothing ->
                    ""

                Just user ->
                    user



-- HTTP


getBookmarks : String -> Cmd Msg
getBookmarks user =
    Api.send GotBookmarks (Api.withBasePath "//localhost:8080" (Api.Request.Bookmarks.getBookmarks <| user))



-- ユーザー向け通知メッセージ


infomation_loading =
    "ロード中..."


infomation_json_load_error =
    "JSON の読み込みに失敗しました"
