port module Update.Update exposing (update)

import Model.Model as Model exposing (Model(..), Modifier(..), Msg(..), Page(..))
import Update.Loading.Update as LoadingUpdate
import Update.NoData.Update as NoDataUpdate
import Update.Show.Update as ShowUpdate


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case model of
        NoData key zone_ posix_ ->
            NoDataUpdate.update msg key zone_ posix_

        Loading page data ->
            LoadingUpdate.update msg page data

        Show page data modifier ->
            ShowUpdate.update msg page data modifier
