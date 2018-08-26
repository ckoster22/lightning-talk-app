module Views.Admin.Admin exposing (view)

import Helpers.ErrorHandling as ErrorHandling
import Html exposing (Html, button, div, form, input, text)
import Html.Attributes exposing (defaultValue, placeholder, type_, value)
import Html.Events exposing (onInput, onSubmit)
import Model.Model as Model exposing (Data, Modifier(..), Msg(..), Page(..))
import Model.RoundModel as Round
import Time exposing (Time)


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


roundCreateForm : String -> Time -> Html Msg
roundCreateForm theme startTime =
    form
        [ onSubmit CreateRoundSubmit ]
        [ themeInput theme startTime
        , startDateTimeInput theme startTime
        , button [ type_ "submit" ] [ text "Submit" ]
        ]


themeInput : String -> Time -> Html Msg
themeInput theme startTime =
    input
        [ value theme
        , placeholder "Theme"
        , onInput (\input -> UpdateRoundCreateFormModel ( input, startTime ))
        ]
        []


startDateTimeInput : String -> Time -> Html Msg
startDateTimeInput theme startTime =
    input
        [ toString startTime |> defaultValue
        , placeholder "Date/Time"
        , onInput (\input -> UpdateRoundCreateFormModel ( theme, parseInputTime input ))
        ]
        []


parseInputTime : String -> Float
parseInputTime timeStr =
    case String.toFloat timeStr of
        Ok time ->
            time

        Err err ->
            0
