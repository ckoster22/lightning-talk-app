module Views.ContentArea.Content exposing (view)

import Html exposing (Html, div, h1, text)
import Html.Attributes exposing (classList)
import Model.Model as Model exposing (Data, Model(..), Modifier(..), Msg(..), Page(..))
import Views.ContentArea.LTTable.Container as Container
import Views.ContentArea.DetailPanel.DetailPanel as DetailPanel


view : Page -> Data -> Modifier -> Html Msg
view page data modifier =
    let
        shouldBlur =
            case modifier of
                WithDeletePrompt _ ->
                    True

                WithDeletingPrompt _ _ ->
                    True

                WithDeletePromptError _ _ ->
                    True

                _ ->
                    False
    in
        div
            [ classList
                [ ( "blur", shouldBlur )
                , ( "flex", True )
                , ( "flex-auto", True )
                ]
            ]
            [ Container.view page data modifier
            , DetailPanel.view page data modifier
            ]
