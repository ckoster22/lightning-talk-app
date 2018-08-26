module Main exposing (main)

import Date
import Helpers.RoutingHelper as RoutingHelper
import Model.Model as Model exposing (Model(..), Msg(..))
import Navigation exposing (Location)
import Update.Update exposing (subscriptions, update)
import Views.App exposing (view)


type alias Args =
    { initialTime : Float }


main : Program Args Model Msg
main =
    Navigation.programWithFlags
        RoutingHelper.locationToMsg
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : Args -> Location -> ( Model, Cmd Msg )
init args location =
    let
        cmds =
            Cmd.batch
                -- UrlChange doesn't happen automatically so we manually modify
                -- the url to let the update function do its thing
                [ Navigation.modifyUrl location.hash ]
    in
    ( NoData (Date.fromTime args.initialTime)
    , cmds
    )
