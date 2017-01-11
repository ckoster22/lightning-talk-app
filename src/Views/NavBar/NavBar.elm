module Views.NavBar.NavBar exposing (view)

import Html exposing (Html, div, button, text, h1)
import Html.Attributes exposing (class, classList, height, width, title)
import Model.Model as Model exposing (Msg(..), Modifier)
import Views.Buttons.NavButton exposing (navButton, NavButtonArgs)
import Views.Buttons.ActionButton exposing (actionButton, ActionButtonArgs)
import Views.Icons.Icon exposing (icon)
import Views.NavBar.NavBarSelector exposing (selector, ViewModel)
import Helpers.SelectorHelper exposing ((<<<<))


view : Modifier -> List NavButtonArgs -> List ActionButtonArgs -> Html Msg
view =
    navBarView <<<< selector


navBarView : ViewModel -> Html Msg
navBarView viewModel =
    div
        [ classList
            [ ( "blur", viewModel.shouldBlur )
            , ( "nav-bar", True )
            , ( "flex", True )
            , ( "flex-none", True )
            ]
        ]
        [ div
            [ class "flex flex-auto justify-between"
            ]
            [ logoAndNavButtons viewModel.navButtons
            , actionButtons viewModel.actionButtonsArgs
            ]
        ]


logoAndNavButtons : List NavButtonArgs -> Html Msg
logoAndNavButtons navButtonsArgs =
    let
        renderedNavButtons =
            List.map navButton navButtonsArgs
    in
        div [ class "flex" ]
            [ div [ class "self-center ml2 lt-logo" ]
                [ icon "lt-logo" ]
            , h1 [ class "self-center ml1 mr4" ]
                [ text "Lightning Talks" ]
            , div [ class "flex self-strech justify-center" ]
                renderedNavButtons
            ]


actionButtons : List ActionButtonArgs -> Html Msg
actionButtons actionButtonsArgs =
    let
        renderedActionButtons =
            List.map actionButton actionButtonsArgs
    in
        div [ class "flex justify-end" ]
            renderedActionButtons
