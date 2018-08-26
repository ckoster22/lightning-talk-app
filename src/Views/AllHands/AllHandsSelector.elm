module Views.AllHands.AllHandsSelector exposing (ViewModel, selector)

import Date exposing (Date)
import Helpers.DateHelper as DateHelper
import Helpers.ModelHelper as ModelHelper
import Model.LightningTalkModel as LightningTalk
import Model.Model exposing (Data)
import Model.RoundModel as Round


type alias ViewModel =
    { currentRoundDisplayDate : String
    , currentRoundTheme : String
    , currentRoundCollapsedTalks : List (Maybe LightningTalk.Model)
    , nextRoundDisplay : String
    }


selector : Data -> ViewModel
selector data =
    let
        upcomingRounds =
            List.filter (ModelHelper.upcomingRoundFilter data.initialTime) data.rounds
    in
    case upcomingRounds of
        _ :: upcomingRound :: twoRoundsFromNow :: _ ->
            ViewModel
                (getRoundDisplayDate upcomingRound)
                (ModelHelper.getThemeDisplay upcomingRound.theme)
                (getCollapsedTalks upcomingRound)
                (getNextRoundDisplay twoRoundsFromNow)

        _ :: upcomingRound :: _ ->
            ViewModel
                (getRoundDisplayDate upcomingRound)
                (ModelHelper.getThemeDisplay upcomingRound.theme)
                (getCollapsedTalks upcomingRound)
                ""

        _ ->
            ViewModel "" "" [] ""


getRoundDisplayDate : Round.Model -> String
getRoundDisplayDate round =
    let
        date =
            Date.fromTime round.startDateTime

        month =
            date
                |> Date.month
                |> DateHelper.convertMonthToString

        day =
            date
                |> Date.day
                |> toString
    in
    month ++ " " ++ day


getCollapsedTalks : Round.Model -> List (Maybe LightningTalk.Model)
getCollapsedTalks round =
    ModelHelper.collapseLightningTalks [ round.slot1, round.slot2, round.slot3, round.slot4 ]


getNextRoundDisplay : Round.Model -> String
getNextRoundDisplay round =
    let
        date =
            Date.fromTime round.startDateTime

        month =
            date
                |> Date.month
                |> DateHelper.convertMonthToString

        day =
            date
                |> Date.day
                |> toString

        theme =
            ModelHelper.getThemeDisplay round.theme
    in
    month ++ " " ++ day ++ ": " ++ theme
