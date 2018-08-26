module Views.Buttons.ActionButton exposing (ActionButtonArgs, actionButton)

import Html exposing (Html, a, text)
import Html.Attributes exposing (class, href, title)
import Model.Model as Model exposing (Msg)
import Views.Icons.Icon exposing (icon)


type alias ActionButtonArgs =
    { titleText : String
    , route : String
    , buttonIcon : String
    }


actionButton : ActionButtonArgs -> Html Msg
actionButton { titleText, route, buttonIcon } =
    a
        [ class (buttonIcon ++ "-button self-center mr2"), title titleText, href route ]
        [ icon ("icon-" ++ buttonIcon) ]
