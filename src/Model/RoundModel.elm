module Model.RoundModel exposing (Model, roundJsonEncoder, roundJsonDecoder, roundsJsonDecoder, empty)

import Json.Encode as Encode
import Json.Decode exposing (Decoder, at, string, float, list, int, map7, field, nullable)
import Time exposing (Time)
import Model.LightningTalkModel as LightningTalk


type alias Model =
    { id : String
    , startDateTime : Time
    , theme : String
    , slot1 : Maybe LightningTalk.Model
    , slot2 : Maybe LightningTalk.Model
    , slot3 : Maybe LightningTalk.Model
    , slot4 : Maybe LightningTalk.Model
    }


empty : Model
empty =
    Model "" 0 "" Nothing Nothing Nothing Nothing


roundJsonEncoder : Model -> Encode.Value
roundJsonEncoder model =
    Encode.object
        [ ( "id", Encode.string model.id )
        , ( "startDateTime", Encode.float model.startDateTime )
        , ( "theme", Encode.string model.theme )
        , ( "slot1", slotEncoder model.slot1 )
        , ( "slot2", slotEncoder model.slot2 )
        , ( "slot3", slotEncoder model.slot3 )
        , ( "slot4", slotEncoder model.slot4 )
        ]


slotEncoder : Maybe LightningTalk.Model -> Encode.Value
slotEncoder maybeTalk =
    case maybeTalk of
        Just talk ->
            LightningTalk.ltJsonEncoder talk

        Nothing ->
            Encode.null


roundsJsonDecoder : Decoder (List Model)
roundsJsonDecoder =
    list roundJsonDecoder


roundJsonDecoder : Decoder Model
roundJsonDecoder =
    map7
        Model
        (field "id" string)
        (field "startDateTime" float)
        (field "theme" string)
        (field "slot1" (nullable LightningTalk.ltJsonDecoder))
        (field "slot2" (nullable LightningTalk.ltJsonDecoder))
        (field "slot3" (nullable LightningTalk.ltJsonDecoder))
        (field "slot4" (nullable LightningTalk.ltJsonDecoder))
