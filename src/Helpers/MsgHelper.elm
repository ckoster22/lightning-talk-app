module Helpers.MsgHelper exposing (..)

import Model.Model as Model exposing (Msg(..))


resultToMsg : (x -> b) -> (a -> b) -> Result x a -> b
resultToMsg errMsg okMsg result =
    case result of
        Ok a ->
            okMsg a

        Err err ->
            errMsg err
