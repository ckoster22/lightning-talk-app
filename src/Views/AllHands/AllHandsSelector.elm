module Views.AllHands.AllHandsSelector exposing (ViewModel, selector)

import Helpers.DateHelper as DateHelper
import Helpers.ModelHelper as ModelHelper
import Model.LightningTalkModel as LightningTalk
import Model.Model exposing (Data)
import Model.RoundModel as Round
import Time exposing (Zone, toDay, toMonth)


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
                (getRoundDisplayDate data.zone upcomingRound)
                (ModelHelper.getThemeDisplay upcomingRound.theme)
                (getCollapsedTalks upcomingRound)
                (getNextRoundDisplay data.zone twoRoundsFromNow)

        _ :: upcomingRound :: _ ->
            ViewModel
                (getRoundDisplayDate data.zone upcomingRound)
                (ModelHelper.getThemeDisplay upcomingRound.theme)
                (getCollapsedTalks upcomingRound)
                ""

        _ ->
            ViewModel "" "" [] ""


getRoundDisplayDate : Zone -> Round.Model -> String
getRoundDisplayDate zone round =
    let
        month =
            toMonth zone round.startDateTime
                |> DateHelper.convertMonthToString

        day =
            toDay zone round.startDateTime
                |> String.fromInt
    in
    month ++ " " ++ day


getCollapsedTalks : Round.Model -> List (Maybe LightningTalk.Model)
getCollapsedTalks round =
    ModelHelper.collapseLightningTalks [ round.slot1, round.slot2, round.slot3, round.slot4 ]


getNextRoundDisplay : Zone -> Round.Model -> String
getNextRoundDisplay zone round =
    let
        theme =
            ModelHelper.getThemeDisplay round.theme
    in
    getRoundDisplayDate zone round ++ ": " ++ theme
