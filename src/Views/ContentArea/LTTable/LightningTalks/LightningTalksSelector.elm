module Views.ContentArea.LTTable.LightningTalks.LightningTalksSelector exposing (RoundViewModel, TimeslotViewModel, ViewModel, selector)

import Helpers.DateHelper exposing (convertMonthToString, getDateFromEpoch, millisecondsInHour)
import Helpers.ModelHelper as ModelHelper
import Model.LightningTalkModel as LightningTalk
import Model.Model exposing (Data, Modifier(..), Msg(..), Page(..), Timeslot)
import Model.RoundModel as Round
import Time exposing (Posix, Zone)


type alias ViewModel =
    { rounds : List RoundViewModel }


type alias TimeslotViewModel =
    { clickMsg : Msg
    , isSelected : Bool
    , maybeTalk : Maybe LightningTalk.Model
    , startTime : String
    }


type alias RoundViewModel =
    { round : Round.Model
    , isEditing : Bool
    , slotModels : List TimeslotViewModel
    , themeDisplay : String
    , startTimeDisplay : String
    }


selector : Page -> Data -> Modifier -> ViewModel
selector page data modifier =
    let
        isPreviousPage =
            page == PreviousTalks

        roundsToDisplay =
            if isPreviousPage then
                getFilteredRounds previousRoundsFilter data
                    |> List.sortBy (.startDateTime >> Time.posixToMillis)
                    |> List.reverse

            else
                getFilteredRounds upcomingRoundsFilter data
                    |> List.sortBy (.startDateTime >> Time.posixToMillis)
    in
    roundsToDisplay
        |> List.map (transformRoundToViewModel modifier isPreviousPage data.zone)
        |> ViewModel


previousRoundsFilter : Posix -> Round.Model -> Bool
previousRoundsFilter initialDate round =
    Time.posixToMillis initialDate >= Time.posixToMillis round.startDateTime + millisecondsInHour


upcomingRoundsFilter : Posix -> Round.Model -> Bool
upcomingRoundsFilter initialDate round =
    not (previousRoundsFilter initialDate round)


getFilteredRounds : (Posix -> Round.Model -> Bool) -> Data -> List Round.Model
getFilteredRounds filter data =
    List.filter (filter data.initialTime) data.rounds


transformRoundToViewModel : Modifier -> Bool -> Zone -> Round.Model -> RoundViewModel
transformRoundToViewModel modifier isPreviousPage zone round =
    let
        ( isEditing, roundToShow, maybeSelectedTimeslot ) =
            case modifier of
                WithRoundEditing editRound ->
                    if editRound.id == round.id then
                        ( True, editRound, Nothing )

                    else
                        ( False, round, Nothing )

                WithTimeslotSelected timeslot ->
                    ( False, round, Just timeslot )

                _ ->
                    ( False, round, Nothing )

        slotModels =
            transformSlotsToViewModel round maybeSelectedTimeslot isPreviousPage zone

        themeDisplay =
            ModelHelper.getThemeDisplay round.theme

        startTimeDisplay =
            getDateFromEpoch roundToShow.startDateTime zone ++ ":"
    in
    RoundViewModel roundToShow isEditing slotModels themeDisplay startTimeDisplay


transformSlotsToViewModel : Round.Model -> Maybe Timeslot -> Bool -> Zone -> List TimeslotViewModel
transformSlotsToViewModel round maybeSelectedTimeslot isPreviousPage zone =
    let
        slot1ViewModel =
            if isPreviousPage && round.slot1 == Nothing then
                []

            else
                [ createTimeslotViewModel round.slot1 0 zone round (isSlotSelected maybeSelectedTimeslot round 0) ]

        slot2ViewModel =
            if isPreviousPage && round.slot2 == Nothing then
                []

            else
                [ createTimeslotViewModel round.slot2 600000 zone round (isSlotSelected maybeSelectedTimeslot round 600000) ]

        slot3ViewModel =
            if isPreviousPage && round.slot3 == Nothing then
                []

            else
                [ createTimeslotViewModel round.slot3 1200000 zone round (isSlotSelected maybeSelectedTimeslot round 1200000) ]

        slot4ViewModel =
            if isPreviousPage && round.slot4 == Nothing then
                []

            else
                [ createTimeslotViewModel round.slot4 1800000 zone round (isSlotSelected maybeSelectedTimeslot round 1800000) ]
    in
    slot4ViewModel
        |> List.append slot3ViewModel
        |> List.append slot2ViewModel
        |> List.append slot1ViewModel


createTimeslotViewModel : Maybe LightningTalk.Model -> Int -> Zone -> Round.Model -> Bool -> TimeslotViewModel
createTimeslotViewModel maybeTalk offsetMs zone round isSelected =
    let
        clickMsg =
            SelectTimeslot (Timeslot round offsetMs maybeTalk)

        startTime =
            (Time.posixToMillis round.startDateTime + offsetMs)
                |> Time.millisToPosix
                |> ModelHelper.getTalkStartTime zone
    in
    TimeslotViewModel clickMsg isSelected maybeTalk startTime


isSlotSelected : Maybe Timeslot -> Round.Model -> Int -> Bool
isSlotSelected maybeTimeslot round expectedOffsetMs =
    case maybeTimeslot of
        Just timeslot ->
            timeslot.round == round && timeslot.offsetMs == expectedOffsetMs

        Nothing ->
            False
