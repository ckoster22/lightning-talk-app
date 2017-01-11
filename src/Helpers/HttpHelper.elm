module Helpers.HttpHelper exposing (httpGet, httpPost, httpPut, httpDelete)

import Http exposing (Body, Error, Expect, Request)
import Json.Decode as Decode exposing (Decoder)
import Helpers.MsgHelper exposing (..)


{-
   This file exists because Http.get and Http.post are not flexible
   enough in Elm 0.18, specifically because you can't specify a
   timeout or a value for withCredentials.
-}


baseRequest : String -> String -> Expect a -> Body -> Request a
baseRequest verb url expect body =
    Http.request
        { method = verb
        , headers = []
        , url = url
        , body = body
        , expect = expect
        , timeout = Nothing
        , withCredentials = True
        }


httpGet : String -> Decoder a -> (Error -> b) -> (a -> b) -> Cmd b
httpGet url decoder onFail onSucceed =
    let
        request =
            baseRequest "GET" url (Http.expectJson decoder) Http.emptyBody
    in
        Http.send
            (resultToMsg onFail onSucceed)
            request


httpPost : String -> Body -> Decoder a -> (Error -> b) -> (a -> b) -> Cmd b
httpPost url body decoder onFail onSucceed =
    let
        request =
            baseRequest "POST" url (Http.expectJson decoder) body
    in
        Http.send
            (resultToMsg onFail onSucceed)
            request


httpPut : String -> Body -> Decoder a -> (Error -> b) -> (a -> b) -> Cmd b
httpPut url body decoder onFail onSucceed =
    let
        request =
            baseRequest "PUT" url (Http.expectJson decoder) body
    in
        Http.send
            (resultToMsg onFail onSucceed)
            request


httpDelete : String -> Expect a -> (Error -> b) -> (a -> b) -> Cmd b
httpDelete url expect onFail onSucceed =
    let
        request =
            baseRequest "DELETE" url expect Http.emptyBody
    in
        Http.send
            (resultToMsg onFail onSucceed)
            request
