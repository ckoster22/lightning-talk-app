module Helpers.ModelHelper exposing (collapseLightningTalks, findTalk, getFirstTimeslotWithTalkOnPage, getRoundForTalk, getRoundMinusThisTalk, getSlotNum, getStartTimeFromTalk, getTalkStartTime, getThemeDisplay, upcomingRoundFilter)

import Date exposing (Date)
import Helpers.DateHelper exposing (millisecondsInHour)
import Model.LightningTalkModel as LightningTalk
import Model.Model as Model exposing (Data, Page(..), Timeslot)
import Model.RoundModel as Round
import Time exposing (Time)


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


findTalk : Data -> String -> Time -> Maybe LightningTalk.Model
findTalk data roundId offset =
    data.rounds
        |> List.filter (\round -> round.id == roundId)
        |> List.head
        |> Maybe.map
            (\round ->
                if offset == 0 then
                    round.slot1

                else if offset == 600000 then
                    round.slot2

                else if offset == 1200000 then
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


getTalkStartTime : Time -> String
getTalkStartTime startDateTime =
    let
        date =
            Date.fromTime startDateTime

        hour =
            Date.hour date

        hourString =
            if hour > 12 then
                toString <| hour - 12

            else if hour == 0 then
                toString 12

            else
                toString hour

        minute =
            Date.minute date

        minuteString =
            String.padLeft 2 '0' (toString minute)
    in
    hourString ++ ":" ++ minuteString


getStartTimeFromTalk : LightningTalk.Model -> String
getStartTimeFromTalk talk =
    getTalkStartTime talk.startDateTime


upcomingRoundFilter : Date -> Round.Model -> Bool
upcomingRoundFilter initialTime round =
    Date.toTime initialTime < round.startDateTime + millisecondsInHour


getFirstTimeslotWithTalkOnPage : Data -> Page -> Maybe Timeslot
getFirstTimeslotWithTalkOnPage data page =
    data.rounds
        |> List.filter
            (\round ->
                if page == UpcomingTalks then
                    round.startDateTime >= Date.toTime data.initialTime

                else
                    round.startDateTime < Date.toTime data.initialTime
            )
        |> List.sortBy .startDateTime
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
