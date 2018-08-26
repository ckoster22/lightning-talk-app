module Main exposing (main)

-- import Helpers.RoutingHelper as RoutingHelper

import Browser
import Browser.Navigation as Nav
import Model.Model as Model exposing (Model(..), Msg(..))
import Task
import Time
import Update.Update exposing (update)
import Url
import Views.App exposing (view)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init _ url key =
    ( NoData key Nothing Nothing
    , Task.map2 (\posix zone -> ( posix, zone )) Time.now Time.here
        |> Task.perform PosixZoneReceived
    )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
