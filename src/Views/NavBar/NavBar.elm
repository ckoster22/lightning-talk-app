module Views.NavBar.NavBar exposing (view)

import Html exposing (Html, button, div, h1, text)
import Html.Attributes exposing (class, classList, height, title, width)
import Model.Model as Model exposing (Modifier, Msg(..))
import Views.Buttons.ActionButton exposing (ActionButtonArgs, actionButton)
import Views.Buttons.NavButton exposing (NavButtonArgs, navButton)
import Views.Icons.Icon exposing (icon)
import Views.NavBar.NavBarSelector exposing (ViewModel, selector)


view : Modifier -> List NavButtonArgs -> List ActionButtonArgs -> Html Msg
view modifier navButtons actionButtonsArgs =
    navBarView <| selector modifier navButtons actionButtonsArgs


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
