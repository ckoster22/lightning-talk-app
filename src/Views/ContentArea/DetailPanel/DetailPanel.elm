module Views.ContentArea.DetailPanel.DetailPanel exposing (view)

import Helpers.ModelHelper as ModelHelper
import Html exposing (Html, a, button, div, h1, h3, h4, img, p, text)
import Html.Attributes exposing (class, href, src, title)
import Html.Events exposing (onClick)
import Model.LightningTalkModel as LightningTalkModel
import Model.Model as Model exposing (Data, Model(..), Modifier(..), Msg(..), Page(..), Timeslot)
import Model.RoundModel as Round
import Time exposing (Time)
import Views.Icons.Icon exposing (icon)


view : Page -> Data -> Modifier -> Html Msg
view page data modifier =
    let
        maybeTimeslot =
            case modifier of
                WithTimeslotSelected timeslot ->
                    Just timeslot

                _ ->
                    Nothing

        content =
            case maybeTimeslot of
                Just timeslot ->
                    case timeslot.model of
                        Just talk ->
                            talkDetails page talk timeslot.round timeslot.offset

                        Nothing ->
                            emptyDetails timeslot

                Nothing ->
                    [ div [] [] ]
    in
    div
        [ class "details-panel flex-none" ]
        content


talkDetails : Page -> LightningTalkModel.Model -> Round.Model -> Time -> List (Html Model.Msg)
talkDetails page talk round offset =
    [ div
        [ class "flex" ]
      <|
        div [ class "flex-auto" ] [ h1 [ class "mt0" ] [ text talk.topic ] ]
            :: getOptionsHtml page talk round offset
    , h4 [] [ text talk.speakers ]
    , h3 [] [ text (ModelHelper.getStartTimeFromTalk talk) ]
    , p [] [ text talk.description ]
    ]


emptyDetails : Timeslot -> List (Html Model.Msg)
emptyDetails timeslot =
    let
        route =
            "/#create/" ++ timeslot.round.id ++ "/" ++ toString timeslot.offset
    in
    [ div
        [ class "flex lt-no-talk" ]
        [ div [ class "flex-auto inner" ]
            [ p [] [ text "There is no talk scheduled for this time slot." ]
            , icon "lt-logo"
            , a [ class "add-talk-button-full", title "Create a talk", href route ] [ text "Create a talk" ]
            ]
        ]
    ]


getOptionsHtml : Page -> LightningTalkModel.Model -> Round.Model -> Time -> List (Html Msg)
getOptionsHtml page talk round offset =
    if page == UpcomingTalks then
        [ div [] [ a [ onClick PromptForTalkDeletion, title "Delete talk", class "detail-button" ] [ icon "icon-delete" ] ]
        , div [] [ a [ title "Update talk", class "detail-button", href ("/#update/" ++ round.id ++ "/" ++ toString offset) ] [ icon "icon-edit" ] ]
        ]

    else
        []
