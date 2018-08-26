module Views.AllHands.AllHands exposing (view)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (class)
import Model.LightningTalkModel as LightningTalk
import Model.Model as Model exposing (Data, Msg)
import Views.AllHands.AllHandsSelector exposing (ViewModel, selector)
import Views.Icons.Icon exposing (icon)


view : Data -> Html Msg
view =
    viewWithBothRounds << selector


viewWithBothRounds : ViewModel -> Html Msg
viewWithBothRounds viewModel =
    div
        []
        [ frameBar1
        , div
            [ class "all-hands-outer-frame flex justify-between" ]
            [ div
                [ class "background-image" ]
                []
            , div
                [ class "background-image-color"
                ]
                []
            , div
                [ class "background-image-mask"
                ]
                []
            , div
                [ class "logo-lockup"
                ]
                [ icon "lt-logo"
                , h1 [] [ text "Lightning Talks" ]
                ]
            , slideContent viewModel
            ]
        , frameBar2
        ]


frameBar1 : Html Msg
frameBar1 =
    div
        [ class "flex flex-auto justify-between hash-frame" ]
        [ divBox1
        , divBox2
        ]


frameBar2 : Html Msg
frameBar2 =
    div
        [ class "flex flex-auto justify-between hash-frame" ]
        [ divBox3
        , divBox4
        ]


divBox1 : Html Msg
divBox1 =
    div
        [ class "hash ul" ]
        []


divBox2 : Html Msg
divBox2 =
    div
        [ class "hash ur" ]
        []


divBox3 : Html Msg
divBox3 =
    div
        [ class "hash ll" ]
        []


divBox4 : Html Msg
divBox4 =
    div
        [ class "hash lr" ]
        []


heading : ViewModel -> Html Msg
heading viewModel =
    div
        [ class "round-header" ]
        [ div
            [ class "round-date" ]
            [ text viewModel.currentRoundDisplayDate ]
        , div
            [ class "theme-title" ]
            [ text viewModel.currentRoundTheme ]
        ]


slideContent : ViewModel -> Html Msg
slideContent viewModel =
    div
        [ class "slide-content" ]
        [ heading viewModel
        , currentRoundSection viewModel
        , nextRoundThemeSection viewModel
        ]


currentRoundSection : ViewModel -> Html Msg
currentRoundSection viewModel =
    div
        [ class "talk-round" ]
        (List.map lightningTalkItem viewModel.currentRoundCollapsedTalks)


lightningTalkItem : Maybe LightningTalk.Model -> Html Msg
lightningTalkItem maybeTalk =
    case maybeTalk of
        Just talk ->
            div [ class "talk-row" ]
                [ div
                    [ class "talk-title" ]
                    [ text talk.topic ]
                , div
                    [ class "talk-author" ]
                    [ text talk.speakers ]
                ]

        Nothing ->
            div [ class "talk-row" ]
                [ div
                    [ class "no-talk" ]
                    [ text "Time Slot Available" ]
                ]


nextRoundThemeSection : ViewModel -> Html Msg
nextRoundThemeSection viewModel =
    div
        [ class "next-round" ]
        [ text viewModel.nextRoundDisplay ]
