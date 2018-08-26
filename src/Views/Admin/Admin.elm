module Views.Admin.Admin exposing (view)

import Helpers.ErrorHandling as ErrorHandling
import Html exposing (Html, button, div, form, input, text)
import Html.Attributes exposing (placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Model.Model as Model exposing (Data, Modifier(..), Msg(..), Page(..))
import Model.RoundModel as Round
import Time exposing (Posix)


view : Page -> Data -> Modifier -> Html Msg
view page data modifier =
    let
        children =
            case modifier of
                WithRound ( theme, startTime ) ->
                    [ roundCreateForm theme startTime ]

                WithRoundFormError ( theme, startTime ) httpError ->
                    [ roundCreateError <| ErrorHandling.getMessageFromError httpError
                    , roundCreateForm theme startTime
                    ]

                _ ->
                    []
    in
    div
        []
        children


roundCreateError : String -> Html Msg
roundCreateError error =
    text error


roundCreateForm : String -> Posix -> Html Msg
roundCreateForm theme startTime =
    form
        [ onSubmit CreateRoundSubmit ]
        [ themeInput theme startTime
        , startDateTimeInput theme startTime
        , button [ type_ "submit" ] [ text "Submit" ]
        ]


themeInput : String -> Posix -> Html Msg
themeInput theme startTime =
    input
        [ value theme
        , placeholder "Theme"
        , onInput (\input -> UpdateRoundCreateFormModel ( input, startTime ))
        ]
        []


startDateTimeInput : String -> Posix -> Html Msg
startDateTimeInput theme startTime =
    input
        [ Time.posixToMillis startTime |> String.fromInt |> value
        , placeholder "Date/Time"
        , onInput (\input -> UpdateRoundCreateFormModel ( theme, parseInputTime input ))
        ]
        []


parseInputTime : String -> Posix
parseInputTime timeStr =
    case String.toInt timeStr of
        Just time ->
            Time.millisToPosix time

        Nothing ->
            Time.millisToPosix 0
