module Helpers.DateHelper exposing (convertMonthToString, getDateFromEpoch, millisecondsInHour)

import Time exposing (Month(..), Posix, Zone, toDay, toMonth, toYear)


millisecondsInHour : Int
millisecondsInHour =
    3600000


getDateFromEpoch : Posix -> Zone -> String
getDateFromEpoch posix timezone =
    let
        year =
            toYear timezone posix

        month =
            toMonth timezone posix

        day =
            toDay timezone posix

        monthString =
            convertMonthToString month
    in
    convertMonthToString month ++ " " ++ String.fromInt day ++ ", " ++ String.fromInt year


convertMonthToString : Month -> String
convertMonthToString month =
    case month of
        Jan ->
            "January"

        Feb ->
            "February"

        Mar ->
            "March"

        Apr ->
            "April"

        May ->
            "May"

        Jun ->
            "June"

        Jul ->
            "July"

        Aug ->
            "August"

        Sep ->
            "September"

        Oct ->
            "October"

        Nov ->
            "November"

        Dec ->
            "December"
