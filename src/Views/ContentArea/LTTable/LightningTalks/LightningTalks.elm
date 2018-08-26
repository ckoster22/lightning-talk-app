module Views.ContentArea.LTTable.LightningTalks.LightningTalks exposing (view)

import Html exposing (Html, button, div, h3, h4, input, li, span, text, ul)
import Html.Attributes exposing (class, classList, title, value)
import Html.Events exposing (onClick, onInput)
import Model.LightningTalkModel as LightningTalk
import Model.Model as Model exposing (Data, Model(..), Modifier(..), Msg(..), Page(..), Timeslot)
import Views.ContentArea.LTTable.LightningTalks.LightningTalksSelector exposing (RoundViewModel, TimeslotViewModel, ViewModel, selector)
import Views.Icons.Icon exposing (icon)


view : Page -> Data -> Modifier -> Html Msg
view page data modifier =
    talkListView <| selector page data modifier


talkListView : ViewModel -> Html Msg
talkListView viewModel =
    div
        [ class "talk-list-container flex-auto" ]
        [ roundsContainer viewModel ]


roundsContainer : ViewModel -> Html Msg
roundsContainer viewModel =
    div
        []
        (List.map roundElement viewModel.rounds)


roundElement : RoundViewModel -> Html Msg
roundElement roundViewModel =
    div []
        [ div [ class "round-title" ]
            [ span [] [ text roundViewModel.startTimeDisplay ]
            , roundThemeElement roundViewModel
            ]
        , div []
            (List.map timeslotElement roundViewModel.slotModels)
        ]


timeslotElement : TimeslotViewModel -> Html Msg
timeslotElement timeslotViewModel =
    div
        [ onClick timeslotViewModel.clickMsg
        , classList
            [ ( "selected", timeslotViewModel.isSelected )
            , ( "talk-item", True )
            , ( "flex", True )
            ]
        ]
        [ timeslotTitle timeslotViewModel.maybeTalk
        , div [ class "talk-time" ] [ text timeslotViewModel.startTime ]
        ]


timeslotTitle : Maybe LightningTalk.Model -> Html Msg
timeslotTitle maybeTalk =
    case maybeTalk of
        Just talk ->
            div [ class "flex-auto" ]
                [ div [ class "talk-title" ] [ text talk.topic ]
                , div [ class "talk-author" ] [ text talk.speakers ]
                ]

        Nothing ->
            div [ class "flex-auto" ]
                [ div [ class "talk-title-empty" ] [ text "Empty Time Slot" ] ]


roundThemeElement : RoundViewModel -> Html Msg
roundThemeElement { round, isEditing, themeDisplay } =
    if isEditing then
        span []
            [ input [ value round.theme, onInput (\input -> UpdateRound { round | theme = input }) ] []
            , div [ class "round-update-button save", onClick UpdateRoundSubmit, title "Save changes" ] [ icon "icon-check" ]
            , div [ class "round-update-button cancel", onClick Cancel, title "Cancel" ] [ icon "icon-cancel" ]
            ]

    else
        span [ onClick (SetRoundIsEditing round) ] [ text themeDisplay ]
