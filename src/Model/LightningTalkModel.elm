module Model.LightningTalkModel exposing (Model, empty, ltJsonDecoder, ltJsonEncoder)

import Json.Decode as Decode exposing (Decoder, at, field, list, map3, string)
import Json.Encode as Encode exposing (object, string)


type alias Model =
    { description : String
    , speakers : String
    , topic : String
    }


empty : Model
empty =
    Model "" "" ""


ltJsonEncoder : Model -> Encode.Value
ltJsonEncoder model =
    Encode.object
        [ ( "description", Encode.string model.description )
        , ( "speakers", Encode.string model.speakers )
        , ( "topic", Encode.string model.topic )
        ]


ltJsonDecoder : Decoder Model
ltJsonDecoder =
    map3
        (\desc speakers topic -> Model desc speakers topic)
        (field "description" Decode.string)
        (field "speakers" Decode.string)
        (field "topic" Decode.string)
