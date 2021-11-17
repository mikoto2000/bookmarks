module TestMain exposing (..)

import Expect exposing (Expectation)
import Fuzz exposing (Fuzzer, int, list, string)
import Test exposing (..)

import Main exposing (User(..), extractUserFromUrlString)


suite : Test
suite =
    describe "URL parse test."
        [ describe "extractUserFromUrlString"
            [ test "one `user` query parameter." <|
                \_ ->
                        let
                            url = "http://localhost/bookmarks/?user=mikoto2000"
                            expect = OnceUser "mikoto2000"
                        in
                            Expect.equal expect (extractUserFromUrlString url)
            , test "no `user` query parameter." <|
                \_ ->
                        let
                            url = "http://localhost/bookmarks"
                            expect = NothingUser
                        in
                            Expect.equal expect (extractUserFromUrlString url)
            , test "two `user` query parameter." <|
                \_ ->
                        let
                            url = "http://localhost/bookmarks?user=mikoto2000&user=mikoto3000"
                            expect = MultipleUser
                        in
                            Expect.equal expect (extractUserFromUrlString url)
            ]
        ]
