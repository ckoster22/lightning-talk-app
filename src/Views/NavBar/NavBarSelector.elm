module Views.NavBar.NavBarSelector exposing (selector, ViewModel)

import Model.Model exposing (Data, Modifier(..), Page(..))
import Views.Buttons.NavButton exposing (NavButtonArgs)
import Views.Buttons.ActionButton exposing (ActionButtonArgs)


type alias ViewModel =
    { shouldBlur : Bool
    , navButtons : List NavButtonArgs
    , actionButtonsArgs : List ActionButtonArgs
    }


selector : Modifier -> List NavButtonArgs -> List ActionButtonArgs -> ViewModel
selector modifier navButtons actionButtonsArgs =
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
        ViewModel shouldBlur navButtons actionButtonsArgs
