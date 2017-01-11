module Views.TalkForm.TalkForm exposing (view)

import Html exposing (Html, div, text, input, button, h2, a, select, textarea, option, label)
import Html.Attributes exposing (value, placeholder, class, classList, rows, for, name, type_, checked, selected, id, disabled, title)
import Html.Events exposing (onInput, onClick, onCheck)
import Model.Model exposing (Data, FormError(..), FormType(..), LightningTalkFormModel, Msg(..), Model(..), Modifier(..), Page(..))
import Views.Icons.Icon exposing (icon)
import Helpers.SelectorHelper exposing ((<<<))
import Views.TalkForm.TalkFormSelector exposing (selector, RoundViewModel, TimeslotViewModel, ViewModel)


view : Data -> Modifier -> Html Msg
view =
    formView <<< selector


formView : ViewModel -> Html Msg
formView viewModel =
    div
        [ class "slide-form" ]
        [ errorSection viewModel.generalError
        , div
            [ class "form-content" ]
            [ heading
            , topicInput viewModel
            , speakersInput viewModel
            , roundSelect viewModel
            , timeslotGroupSection viewModel
            , descriptionTextArea viewModel
            , actionButtons viewModel
            ]
        ]


errorSection : Maybe String -> Html Msg
errorSection generalError =
    case generalError of
        Just errorMessage ->
            div [ class "system-error" ]
                [ icon "exclamation-circle"
                , text errorMessage
                ]

        _ ->
            div [] []


heading : Html Msg
heading =
    h2
        [ class "h4 caps center" ]
        [ text "New Lightning Talk"
        ]


topicInput : ViewModel -> Html Msg
topicInput { formModel, onTopicChange, hasTopicError } =
    input
        [ value formModel.model.topic
        , onInput onTopicChange
        , placeholder "What's your talk called?"
        , classList
            [ ( "field-error", hasTopicError ) ]
        ]
        []


speakersInput : ViewModel -> Html Msg
speakersInput { formModel, onSpeakersChange, hasSpeakersError } =
    input
        [ value formModel.model.speakers
        , onInput onSpeakersChange
        , placeholder "Who will be speaking?"
        , classList [ ( "field-error", hasSpeakersError ) ]
        ]
        []


roundSelect : ViewModel -> Html Msg
roundSelect { onRoundChange, upcomingRounds } =
    div [ class "custom-select" ]
        [ select
            [ onInput onRoundChange ]
            (List.map viewRound upcomingRounds)
        ]


timeslotGroupSection : ViewModel -> Html Msg
timeslotGroupSection viewModel =
    case viewModel.selectedRound of
        Just roundViewModel ->
            div
                [ classList
                    [ ( "time-slot-group", True )
                    , ( "field-error", viewModel.hasTimeslotError )
                    ]
                ]
                (List.map viewTimeslot roundViewModel.slots)

        Nothing ->
            div [] []


descriptionTextArea : ViewModel -> Html Msg
descriptionTextArea { formModel, onDescriptionChange, hasDescriptionError } =
    textarea
        [ rows 10
        , value formModel.model.description
        , onInput onDescriptionChange
        , placeholder "Give a brief talk description"
        , classList [ ( "field-error", hasDescriptionError ) ]
        ]
        []


actionButtons : ViewModel -> Html Msg
actionButtons { submit } =
    div [ class "buttons" ]
        [ button
            [ onClick Cancel
            , title "Cancel"
            , class "button"
            ]
            [ text "cancel" ]
        , button
            [ onClick submit.onSubmit
            , title "Submit"
            , class "primary button"
            , disabled submit.isDisabled
            ]
            [ text submit.label ]
        ]


viewRound : RoundViewModel -> Html Msg
viewRound roundViewModel =
    option
        [ value roundViewModel.round.id
        , selected roundViewModel.isSelected
        , disabled roundViewModel.isFull
        ]
        [ text roundViewModel.displayText ]


viewTimeslot : TimeslotViewModel -> Html Msg
viewTimeslot { timeslotId, isChecked, isDisabled, onCheckedHandler, timeDisplay } =
    div []
        [ input
            [ type_ "checkbox"
            , name timeslotId
            , id timeslotId
            , checked isChecked
            , onCheck onCheckedHandler
            , disabled isDisabled
            ]
            []
        , label
            [ for timeslotId
            , classList [ ( "disabled", isDisabled ) ]
            ]
            [ text timeDisplay ]
        ]
