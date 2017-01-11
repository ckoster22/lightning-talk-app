module Views.ContentArea.LTTable.LightningTalks.LightningTalksSelector exposing (selector, RoundViewModel, TimeslotViewModel, ViewModel)

import Model.Model exposing (Data, Modifier(..), Msg(..), Page(..), Timeslot)
import Model.LightningTalkModel as LightningTalk
import Model.RoundModel as Round
import Time exposing (Time)
import Date exposing (Date)
import Helpers.DateHelper exposing (millisecondsInHour, getDateFromEpoch, convertMonthToString)
import Helpers.ModelHelper as ModelHelper


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
                    |> List.sortBy .startDateTime
                    |> List.reverse
            else
                getFilteredRounds upcomingRoundsFilter data
                    |> List.sortBy .startDateTime
    in
        roundsToDisplay
            |> List.map (transformRoundToViewModel modifier isPreviousPage)
            |> ViewModel


previousRoundsFilter : Date -> Round.Model -> Bool
previousRoundsFilter initialDate round =
    (Date.toTime initialDate) >= round.startDateTime + millisecondsInHour


upcomingRoundsFilter : Date -> Round.Model -> Bool
upcomingRoundsFilter initialDate round =
    not (previousRoundsFilter initialDate round)


getFilteredRounds : (Date -> Round.Model -> Bool) -> Data -> List Round.Model
getFilteredRounds filter data =
    List.filter (filter data.initialTime) data.rounds


transformRoundToViewModel : Modifier -> Bool -> Round.Model -> RoundViewModel
transformRoundToViewModel modifier isPreviousPage round =
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
            transformSlotsToViewModel round maybeSelectedTimeslot isPreviousPage

        themeDisplay =
            ModelHelper.getThemeDisplay round.theme

        startTimeDisplay =
            getDateFromEpoch roundToShow.startDateTime ++ ":"
    in
        RoundViewModel roundToShow isEditing slotModels themeDisplay startTimeDisplay


transformSlotsToViewModel : Round.Model -> Maybe Timeslot -> Bool -> List TimeslotViewModel
transformSlotsToViewModel round maybeSelectedTimeslot isPreviousPage =
    let
        slot1ViewModel =
            if isPreviousPage && round.slot1 == Nothing then
                []
            else
                [ createTimeslotViewModel round.slot1 0 round (isSlotSelected maybeSelectedTimeslot round 0) ]

        slot2ViewModel =
            if isPreviousPage && round.slot2 == Nothing then
                []
            else
                [ createTimeslotViewModel round.slot2 600000 round (isSlotSelected maybeSelectedTimeslot round 600000) ]

        slot3ViewModel =
            if isPreviousPage && round.slot3 == Nothing then
                []
            else
                [ createTimeslotViewModel round.slot3 1200000 round (isSlotSelected maybeSelectedTimeslot round 1200000) ]

        slot4ViewModel =
            if isPreviousPage && round.slot4 == Nothing then
                []
            else
                [ createTimeslotViewModel round.slot4 1800000 round (isSlotSelected maybeSelectedTimeslot round 1800000) ]
    in
        slot4ViewModel
            |> List.append slot3ViewModel
            |> List.append slot2ViewModel
            |> List.append slot1ViewModel


createTimeslotViewModel : Maybe LightningTalk.Model -> Time -> Round.Model -> Bool -> TimeslotViewModel
createTimeslotViewModel maybeTalk offset round isSelected =
    let
        clickMsg =
            SelectTimeslot (Timeslot round offset maybeTalk)

        startTime =
            ModelHelper.getTalkStartTime (round.startDateTime + offset)
    in
        TimeslotViewModel clickMsg isSelected maybeTalk startTime


isSlotSelected : Maybe Timeslot -> Round.Model -> Time -> Bool
isSlotSelected maybeTimeslot round expectedOffset =
    case maybeTimeslot of
        Just timeslot ->
            timeslot.round == round && timeslot.offset == expectedOffset

        Nothing ->
            False
