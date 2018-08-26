module Views.TalkForm.TalkForm exposing (view)

import Html exposing (Html, a, button, div, h2, input, label, option, select, text, textarea)
import Html.Attributes exposing (checked, class, classList, disabled, for, id, name, placeholder, rows, selected, title, type_, value)
import Html.Events exposing (onCheck, onClick, onInput)
import Model.Model exposing (Data, FormError(..), FormType(..), LightningTalkFormModel, Model(..), Modifier(..), Msg(..), Page(..))
import Time exposing (Zone)
import Views.Icons.Icon exposing (icon)
import Views.TalkForm.TalkFormSelector exposing (RoundViewModel, TimeslotViewModel, ViewModel, selector)


view : Data -> Modifier -> Zone -> Html Msg
view data modifier zone =
    formView <| selector data modifier zone


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
