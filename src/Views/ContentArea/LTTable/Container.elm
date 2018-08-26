module Views.ContentArea.LTTable.Container exposing (view)

import Date exposing (Date)
import Helpers.DateHelper exposing (millisecondsInHour)
import Html exposing (Html, div, li, text, ul)
import Html.Attributes exposing (class)
import Model.Model as Model exposing (Data, Model(..), Modifier(..), Msg(..), Page(..))
import Model.RoundModel as Round
import Views.ContentArea.LTTable.LightningTalks.LightningTalks as LightningTalksView


view : Page -> Data -> Modifier -> Html Msg
view page data modifier =
    div
        [ class "flex flex-auto talkList talk-list overflow-auto" ]
        [ content page data modifier ]


content : Page -> Data -> Modifier -> Html Msg
content page data modifier =
    let
        childrenDivs =
            case page of
                UpcomingTalks ->
                    [ LightningTalksView.view page data modifier ]

                PreviousTalks ->
                    [ LightningTalksView.view page data modifier ]

                _ ->
                    []
    in
    div
        [ class "flex flex-auto" ]
        childrenDivs
