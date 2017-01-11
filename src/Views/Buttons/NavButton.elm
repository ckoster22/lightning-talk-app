module Views.Buttons.NavButton exposing (navButton, NavButtonArgs)

import Html exposing (Html, a, text)
import Html.Attributes exposing (class, title, href)
import Model.Model as Model exposing (Msg)


type alias NavButtonArgs =
    { displayText : String
    , titleText : String
    , route : String
    , isSelected : Bool
    }


navButton : NavButtonArgs -> Html Msg
navButton { displayText, titleText, route, isSelected } =
    let
        initialClass =
            "nav-button flex items-center justify-center"

        finalClass =
            if isSelected then
                initialClass ++ " selected"
            else
                initialClass
    in
        a
            [ class finalClass, title displayText, href route ]
            [ text displayText ]
