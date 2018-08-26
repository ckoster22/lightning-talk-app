module Update.NoData.Update exposing (update)

import Browser.Navigation as Nav exposing (Key)
import Http.RoundHttp exposing (getRounds)
import Model.Model as Model exposing (Data, Model(..), Msg(..), Page(..))
import Time exposing (Posix, Zone)


update : Msg -> Key -> Maybe Zone -> Maybe Posix -> ( Model, Cmd Msg )
update msg key zone_ startTime_ =
    case msg of
        PosixZoneReceived ( posix, zone ) ->
            ( Loading UpcomingTalks (Data [] posix zone key)
            , getRounds
            )

        -- GoToAdminPage ->
        --     ( Loading Admin (Data [] startTime zone key)
        --     , getRounds
        --     )
        -- GoToAllHandsSlidePage ->
        --     ( Loading AllHands (Data [] startTime zone key)
        --     , getRounds
        --     )
        -- GoToCreateForm _ ->
        --     ( Loading CreateEditTalkForm (Data [] startTime zone key)
        --     , getRounds
        --     )
        -- GoToEditForm _ ->
        --     ( Loading CreateEditTalkForm (Data [] startTime zone key)
        --     , getRounds
        --     )
        -- GoToPreviousTalks ->
        --     ( Loading PreviousTalks (Data [] startTime zone key)
        --     , getRounds
        --     )
        -- GoToUpcomingTalks ->
        --     ( Loading UpcomingTalks (Data [] startTime zone key)
        --     , getRounds
        --     )
        -- NavigateTo route ->
        --     ( NoData startTime
        --     , Nav.pushUrl key route
        --     )
        _ ->
            ( NoData key zone_ startTime_
            , Cmd.none
            )
