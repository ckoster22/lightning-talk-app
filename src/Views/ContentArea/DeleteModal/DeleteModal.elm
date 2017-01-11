module Views.ContentArea.DeleteModal.DeleteModal exposing (view)

import Html exposing (Html, div, h1, text, button, p)
import Html.Attributes exposing (class)
import Html.Events exposing (onClick)
import Model.Model as Model exposing (Data, Msg(..), Modifier(..), Page(..))


view : Page -> Data -> Modifier -> Html Msg
view page data modifier =
    let
        maybeDeleteFormModel =
            case modifier of
                WithDeletePrompt deleteFormModel ->
                    Just deleteFormModel

                WithDeletingPrompt deleteFormModel _ ->
                    Just deleteFormModel

                WithDeletePromptError deleteFormModel _ ->
                    Just deleteFormModel

                _ ->
                    Nothing
    in
        case maybeDeleteFormModel of
            Just deleteFormModel ->
                div [ class "flex flex-column modal" ]
                    [ h1 [] [ text <| "Delete " ++ deleteFormModel.talk.topic ++ "?" ]
                    , p [ class "flex flex-auto" ] [ text "Deleting a lightning talk cannot be undone. Are you sure you want to delete this talk?" ]
                    , div [ class "flex flex-auto items-center justify-around confirm-buttons" ]
                        [ div [ onClick Cancel ] [ text "No" ]
                        , div [ onClick DeletingTalk ] [ text "Yes" ]
                        ]
                    ]

            Nothing ->
                div [] []
