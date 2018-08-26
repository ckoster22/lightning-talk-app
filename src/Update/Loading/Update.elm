module Update.Loading.Update exposing (update)

import Helpers.ModelHelper as ModelHelper
import Model.Model as Model exposing (Data, Model(..), Modifier(..), Msg(..), Page(..))
import Model.RoundModel as Round
import Navigation


update : Msg -> Page -> Data -> ( Model, Cmd Msg )
update msg page data =
    case msg of
        DataRetrieved rounds ->
            handleDataRetrieved page data rounds

        _ ->
            ( Loading page data
            , Cmd.none
            )


handleDataRetrieved : Page -> Data -> List Round.Model -> ( Model, Cmd Msg )
handleDataRetrieved page data rounds =
    let
        nextData =
            { data | rounds = rounds }
    in
    case page of
        AllHands ->
            ( Show AllHands nextData WithNoSelection
            , Cmd.none
            )

        Admin ->
            ( Show Admin nextData (WithRound ( "", 0 ))
            , Cmd.none
            )

        _ ->
            let
                maybeSelectedTimeslot =
                    ModelHelper.getFirstTimeslotWithTalkOnPage nextData page

                modifier =
                    case maybeSelectedTimeslot of
                        Just timeslot ->
                            WithTimeslotSelected timeslot

                        Nothing ->
                            WithNoSelection
            in
            ( Show UpcomingTalks nextData modifier
            , Navigation.modifyUrl "/#upcoming"
            )
