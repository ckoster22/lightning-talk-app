module Views.App exposing (view)

import Browser exposing (Document)
import Html exposing (Html, div, text)
import Html.Attributes exposing (class, classList)
import Model.Model as Model exposing (Model(..), Msg(..), Page(..))
import Views.Admin.Admin as Admin
import Views.AllHands.AllHands as AllHands
import Views.ContentArea.Content as Content
import Views.ContentArea.DeleteModal.DeleteModal as DeleteModal
import Views.Header.Container as Header
import Views.TalkForm.TalkForm as TalkForm


view : Model -> Document Msg
view model =
    { title = "Lightning Talks"
    , body = [ bodyView model ]
    }


bodyView : Model -> Html Msg
bodyView model =
    case model of
        NoData _ _ _ ->
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
                        [ TalkForm.view data modifier data.zone ]

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
