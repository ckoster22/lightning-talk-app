module Main exposing (main)

import Model.Model as Model exposing (Model(..), Msg(..))
import Update.Update exposing (update, subscriptions)
import Views.App exposing (view)
import Navigation exposing (Location)
import Helpers.RoutingHelper as RoutingHelper
import Date


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
                -- UrlChange doesn't happen automatically which kind of sucks
                -- so we manually modify the url to let the update function do
                -- its thing
                [ Navigation.modifyUrl location.hash ]
    in
        NoData (Date.fromTime args.initialTime) ! [ cmds ]
