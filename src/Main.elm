module Main exposing (main, update, view)

import Browser
import Html exposing (Html, a, button, div, li, p, pre, text, ul)
import Html.Attributes exposing (href, id)
import Http exposing (Expect, Metadata)
import Json.Decode exposing (Decoder, field, list, map2)
import List
import String
import Url
import Url.Parser exposing ((<?>), parse, query)
import Url.Parser.Query as Query exposing (Parser)


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- 型定義


type alias Model =
    { user : String, bookmarks : List Bookmark, infomation : String }


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
        [ a [ href bookmark.url ] [ text bookmark.title ] ]



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
queryParser : Parser (Maybe String)
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
    Http.get
        { url = "./users/" ++ user ++ ".json"
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
        (field "title" Json.Decode.string)
        (field "url" Json.Decode.string)



-- ユーザー向け通知メッセージ


infomation_loading =
    "ロード中..."


infomation_json_load_error =
    "JSON の読み込みに失敗しました"
