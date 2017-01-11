module Views.App exposing (..)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import Model.Model as Model exposing (Msg(..), Model(..), Page(..))
import Views.Header.Container as Header
import Views.ContentArea.Content as Content
import Views.TalkForm.TalkForm as TalkForm
import Views.ContentArea.DeleteModal.DeleteModal as DeleteModal
import Views.Admin.Admin as Admin
import Views.AllHands.AllHands as AllHands


view : Model -> Html Msg
view model =
    case model of
        NoData date ->
            div
                [ class "flex flex-auto flex-column" ]
                [ text "No Data" ]

        Loading _ date ->
            div
                [ class "flex flex-auto flex-column" ]
                [ text "Loading Data" ]

        Show page data modifier ->
            case page of
                CreateEditTalkForm ->
                    div
                        [ class "flex flex-auto" ]
                        [ TalkForm.view data modifier ]

                UpcomingTalks ->
                    div
                        [ class "flex flex-auto flex-column" ]
                        [ Header.view page data modifier
                        , Content.view page data modifier
                        , DeleteModal.view page data modifier
                        ]

                PreviousTalks ->
                    div
                        [ class "flex flex-auto flex-column" ]
                        [ Header.view page data modifier
                        , Content.view page data modifier
                        , DeleteModal.view page data modifier
                        ]

                AllHands ->
                    div
                        [ class "flex flex-auto" ]
                        [ AllHands.view data ]

                Admin ->
                    div
                        [ class "flex flex-auto" ]
                        [ Admin.view page data modifier ]
