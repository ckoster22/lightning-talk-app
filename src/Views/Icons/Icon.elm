module Views.Icons.Icon exposing (icon)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Model.Model as Model exposing (Msg(..))
import Svg exposing (svg, use)
import Svg.Attributes exposing (class, height, viewBox, width, xlinkHref)


icon : String -> Html Msg
icon glyph =
    svg
        [ width "1em", height "1em", class "icon" ]
        [ use
            [ xlinkHref ("#" ++ glyph)
            , attribute "href" ("#" ++ glyph)
            ]
            []
        ]
