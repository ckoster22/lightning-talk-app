module Views.Icons.Icon exposing (icon)

import Html exposing (Html, node)
import Html.Attributes exposing (attribute)
import Svg exposing (svg, use)
import Svg.Attributes exposing (width, height, viewBox, class, xlinkHref)
import Model.Model as Model exposing (Msg(..))


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
