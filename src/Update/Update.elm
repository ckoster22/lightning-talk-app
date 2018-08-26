port module Update.Update exposing (subscriptions, update)

import Model.Model as Model exposing (Model(..), Modifier(..), Msg(..), Page(..))
import Update.Loading.Update as LoadingUpdate
import Update.NoData.Update as NoDataUpdate
import Update.Show.Update as ShowUpdate


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        NoData date ->
            NoDataUpdate.update msg date

        Loading page data ->
            LoadingUpdate.update msg page data

        Show page data modifier ->
            ShowUpdate.update msg page data modifier
