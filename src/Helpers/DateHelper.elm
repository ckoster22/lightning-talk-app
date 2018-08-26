module Helpers.DateHelper exposing (convertMonthToString, getDateFromEpoch, millisecondsInHour)

import Date exposing (Month(..))
import Time exposing (Time)


millisecondsInHour : Float
millisecondsInHour =
    3600000


getDateFromEpoch : Time -> String
getDateFromEpoch epoch =
    let
        date =
            Date.fromTime epoch

        year =
            Date.year date

        month =
            Date.month date

        day =
            Date.day date

        monthString =
            convertMonthToString month
    in
    monthString ++ " " ++ toString day ++ ", " ++ toString year


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
