module Helpers.ModelHelper exposing (collapseLightningTalks, findTalk, getFirstTimeslotWithTalkOnPage, getRoundForTalk, getRoundMinusThisTalk, getSlotNum, getStartTimeFromTalk, getTalkStartTime, getThemeDisplay, upcomingRoundFilter)

import Helpers.DateHelper exposing (millisecondsInHour)
import Model.LightningTalkModel as LightningTalk
import Model.Model as Model exposing (Data, Page(..), Timeslot)
import Model.RoundModel as Round
import Time exposing (Posix, Zone)


getRoundForTalk : Data -> LightningTalk.Model -> Maybe Round.Model
getRoundForTalk data talk =
    data.rounds
        |> List.foldl
            (\round maybeRound ->
                case maybeRound of
                    Just _ ->
                        maybeRound

                    Nothing ->
                        if round.slot1 == Just talk then
                            Just round

                        else if round.slot2 == Just talk then
                            Just round

                        else if round.slot3 == Just talk then
                            Just round

                        else if round.slot4 == Just talk then
                            Just round

                        else
                            Nothing
            )
            Nothing


getRoundMinusThisTalk : Round.Model -> LightningTalk.Model -> Round.Model
getRoundMinusThisTalk round talk =
    if round.slot1 == Just talk then
        { round | slot1 = Nothing }

    else if round.slot2 == Just talk then
        { round | slot2 = Nothing }

    else if round.slot3 == Just talk then
        { round | slot3 = Nothing }

    else if round.slot4 == Just talk then
        { round | slot4 = Nothing }

    else
        round


findTalk : Data -> String -> Int -> Maybe LightningTalk.Model
findTalk data roundId offsetMs =
    data.rounds
        |> List.filter (\round -> round.id == roundId)
        |> List.head
        |> Maybe.map
            (\round ->
                if offsetMs == 0 then
                    round.slot1

                else if offsetMs == 600000 then
                    round.slot2

                else if offsetMs == 1200000 then
                    round.slot3

                else
                    round.slot4
            )
        |> Maybe.withDefault Nothing


getSlotNum : Maybe Round.Model -> LightningTalk.Model -> Maybe Int
getSlotNum maybeRound talk =
    case maybeRound of
        Just round ->
            if round.slot1 == Just talk then
                Just 1

            else if round.slot2 == Just talk then
                Just 2

            else if round.slot3 == Just talk then
                Just 3

            else if round.slot4 == Just talk then
                Just 4

            else
                Nothing

        Nothing ->
            Nothing


getTalkStartTime : Zone -> Posix -> String
getTalkStartTime zone startTime =
    let
        hour =
            Time.toHour zone startTime

        hourString =
            if hour > 12 then
                String.fromInt <| hour - 12

            else if hour == 0 then
                String.fromInt 12

            else
                String.fromInt hour

        minute =
            Time.toMinute zone startTime

        minuteString =
            String.padLeft 2 '0' (String.fromInt minute)
    in
    hourString ++ ":" ++ minuteString


getStartTimeFromTalk : LightningTalk.Model -> String
getStartTimeFromTalk talk =
    Debug.todo "calculate talk start time another way"


upcomingRoundFilter : Posix -> Round.Model -> Bool
upcomingRoundFilter initialTime round =
    Time.posixToMillis initialTime < Time.posixToMillis round.startDateTime + millisecondsInHour


getFirstTimeslotWithTalkOnPage : Data -> Page -> Maybe Timeslot
getFirstTimeslotWithTalkOnPage data page =
    data.rounds
        |> List.filter
            (\round ->
                if page == UpcomingTalks then
                    Time.posixToMillis round.startDateTime >= Time.posixToMillis data.initialTime

                else
                    Time.posixToMillis round.startDateTime < Time.posixToMillis data.initialTime
            )
        |> List.sortBy (\round -> Time.posixToMillis round.startDateTime)
        |> List.foldl
            (\round maybeTimeslot ->
                case maybeTimeslot of
                    Just timeslot ->
                        maybeTimeslot

                    Nothing ->
                        if round.slot1 /= Nothing then
                            Just (Timeslot round 0 round.slot1)

                        else if round.slot2 /= Nothing then
                            Just (Timeslot round 600000 round.slot2)

                        else if round.slot3 /= Nothing then
                            Just (Timeslot round 1200000 round.slot3)

                        else if round.slot4 /= Nothing then
                            Just (Timeslot round 1800000 round.slot4)

                        else
                            Nothing
            )
            Nothing


collapseLightningTalks : List (Maybe LightningTalk.Model) -> List (Maybe LightningTalk.Model)
collapseLightningTalks maybeTalks =
    let
        filteredTalks =
            List.filter (\maybeTalk -> maybeTalk /= Nothing) maybeTalks

        emptyTalks =
            List.repeat (4 - List.length filteredTalks) Nothing
    in
    List.append filteredTalks emptyTalks


getThemeDisplay : String -> String
getThemeDisplay theme =
    if theme == "" then
        "Any Topic Welcome!"

    else
        theme
