module Model.LightningTalkModel exposing (Model, ltJsonDecoder, ltJsonEncoder, empty)

import Json.Encode as Encode exposing (object, string)
import Json.Decode as Decode exposing (Decoder, at, string, list, map3, field)
import Time exposing (Time)


type alias Model =
    { description : String
    , speakers : String
    , topic : String
    , startDateTime : Time
    }


empty : Model
empty =
    Model "" "" "" 0


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
        (\desc speakers topic -> Model desc speakers topic 0)
        (field "description" Decode.string)
        (field "speakers" Decode.string)
        (field "topic" Decode.string)
