module Helpers.ErrorHandling exposing (getMessageFromError, handleResponse)

import Http exposing (Error(..), Response)


getMessageFromError : Error -> String
getMessageFromError httpError =
    case httpError of
        BadUrl err ->
            "BadUrl " ++ err

        Timeout ->
            "Timeout"

        NetworkError ->
            "Network error"

        BadStatus response ->
            "Bad Status " ++ handleResponse response

        BadPayload err response ->
            "Bad Payload " ++ err ++ " " ++ handleResponse response


handleResponse : Response String -> String
handleResponse response =
    toString response.status.code ++ ":" ++ response.status.message ++ ":" ++ response.url
