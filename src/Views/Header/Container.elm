module Views.Header.Container exposing (view)

import Html exposing (Html)
import Model.Model as Model exposing (Data, Msg, Model(..), Modifier(..), Page(..))
import Views.NavBar.NavBar as NavBar


view : Page -> Data -> Modifier -> Html Msg
view page data modifier =
    NavBar.view
        modifier
        [ { displayText = "Upcoming"
          , titleText = "Go to upcoming talks page"
          , route = "/#upcoming"
          , isSelected = page == UpcomingTalks
          }
        , { displayText = "Previous"
          , titleText = "Go to previous talk page"
          , route = "/#previous"
          , isSelected = page == PreviousTalks
          }
        ]
        [ { titleText = "Add a talk"
          , route = "/#create"
          , buttonIcon = "plus"
          }
        ]
