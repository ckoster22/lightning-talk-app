module Http.RoundHttp exposing (..)

import Model.RoundModel as Round
import Model.Model as Model exposing (Msg(..))
import Task
import Helpers.HttpHelper exposing (httpGet, httpPost, httpPut)
import Http


getRounds : Cmd Msg
getRounds =
    httpGet
        "/api/rounds"
        Round.roundsJsonDecoder
        DataRetrieveError
        DataRetrieved


createRound : Round.Model -> Cmd Msg
createRound round =
    httpPost
        "/api/rounds"
        (Http.jsonBody (Round.roundJsonEncoder round))
        Round.roundJsonDecoder
        CreateRoundFail
        CreateRoundSuccess


updateRound : Round.Model -> Cmd Msg
updateRound round =
    httpPut
        ("/api/rounds/" ++ round.id)
        (Http.jsonBody (Round.roundJsonEncoder round))
        Round.roundJsonDecoder
        UpdateRoundFail
        UpdateRoundSuccess


createTalk : Round.Model -> Cmd Msg
createTalk round =
    httpPut
        ("/api/rounds/" ++ round.id)
        (Http.jsonBody (Round.roundJsonEncoder round))
        Round.roundJsonDecoder
        CreateTalkFail
        CreateTalkSuccess


updateTalk : Round.Model -> Cmd Msg
updateTalk round =
    httpPut
        ("/api/rounds/" ++ round.id)
        (Http.jsonBody (Round.roundJsonEncoder round))
        Round.roundJsonDecoder
        UpdateTalkFail
        UpdateTalkSuccess


deleteTalk : Round.Model -> Cmd Msg
deleteTalk round =
    httpPut
        ("/api/rounds/" ++ round.id)
        (Http.jsonBody (Round.roundJsonEncoder round))
        Round.roundJsonDecoder
        DeleteTalkFail
        DeleteTalkSuccess
