module Main exposing (main, update, view)

import Browser
import Html exposing (Html, a, button, div, li, p, text, ul)
import Html.Attributes exposing (href, id)
import List
import String


main =
    Browser.element { init = init, update = update, view = view, subscriptions = subscriptions }



-- 型定義


type alias Bookmark =
    { title : String
    , url : String
    }



-- ブックマークのリスト


bookmarks =
    [ { title = "Google"
      , url = "https://www.google.com"
      }
    , { title = "TweetDeck"
      , url = "https://tweetdeck.twitter.com/"
      }
    ]



-- INIT


init : () -> ( (), Cmd () )
init _ =
    ( (), Cmd.none )



-- UPDATE


update _ model =
    ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions model =
    Sub.none


view model =
    div []
        [ div []
            [ div [ id "bookmarks" ]
                [ ul []
                    (List.map to_anchor bookmarks)
                ]
            ]
        ]


to_anchor bookmark =
    li []
        [ a [ href bookmark.url ] [ text bookmark.title ] ]
