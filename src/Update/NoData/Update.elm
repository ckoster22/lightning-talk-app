module Update.NoData.Update exposing (update)

import Date exposing (Date)
import Http.RoundHttp exposing (getRounds)
import Model.Model as Model exposing (Data, Model(..), Msg(..), Page(..))
import Navigation


update : Msg -> Date -> ( Model, Cmd Msg )
update msg date =
    case msg of
        GoToAdminPage ->
            ( Loading Admin (Data [] date)
            , getRounds
            )

        GoToAllHandsSlidePage ->
            ( Loading AllHands (Data [] date)
            , getRounds
            )

        GoToCreateForm _ ->
            ( Loading CreateEditTalkForm (Data [] date)
            , getRounds
            )

        GoToEditForm _ ->
            ( Loading CreateEditTalkForm (Data [] date)
            , getRounds
            )

        GoToPreviousTalks ->
            ( Loading PreviousTalks (Data [] date)
            , getRounds
            )

        GoToUpcomingTalks ->
            ( Loading UpcomingTalks (Data [] date)
            , getRounds
            )

        NavigateTo route ->
            ( NoData date
            , Navigation.newUrl route
            )

        _ ->
            ( NoData date
            , Cmd.none
            )
