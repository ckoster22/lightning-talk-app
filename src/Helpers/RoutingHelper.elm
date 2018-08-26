module Helpers.RoutingHelper exposing (locationToMsg)

import Model.Model as Model exposing (Msg(..), TalkIdentifier)
import Navigation exposing (Location)
import UrlParser as Url exposing ((</>), Parser, int, oneOf, s, string)


routeToMsgParser : Parser (Msg -> a) a
routeToMsgParser =
    Url.oneOf
        [ Url.map GoToAdminPage (s "admin")
        , Url.map GoToAllHandsSlidePage (s "allhands")
        , Url.map GoToUpcomingTalks (s "upcoming")
        , Url.map GoToPreviousTalks (s "previous")
        , Url.map
            (\roundId offset -> GoToCreateForm (Just (TalkIdentifier roundId <| toFloat offset)))
            (s "create" </> string </> int)
        , Url.map (GoToCreateForm Nothing) (s "create")
        , Url.map
            (\roundId offset -> GoToEditForm (TalkIdentifier roundId <| toFloat offset))
            (s "update" </> string </> int)
        ]


locationToMsg : Location -> Msg
locationToMsg location =
    Url.parseHash routeToMsgParser location
        |> Maybe.withDefault (NavigateTo "/#upcoming")
