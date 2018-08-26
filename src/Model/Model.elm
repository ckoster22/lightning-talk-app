module Model.Model exposing (AttributeName, Data, DeleteFormModel, FormError(..), FormType(..), Id, LightningTalkFormModel, Model(..), Modifier(..), Msg(..), Page(..), TalkIdentifier, Timeslot)

import Date exposing (Date)
import Dict exposing (Dict)
import Http
import Model.LightningTalkModel as LightningTalk
import Model.RoundModel as Round
import Time exposing (Time)


type alias Data =
    { rounds : List Round.Model
    , initialTime : Date
    }


type alias Id =
    String


type alias AttributeName =
    String


type alias LightningTalkFormModel =
    { original : LightningTalk.Model
    , model : LightningTalk.Model
    , selectedRound : Maybe Round.Model
    , selectedSlotNum : Maybe Int
    }


type FormError
    = AsyncError Http.Error
    | ValidationError (List AttributeName)
    | TalkNotFoundError


type FormType
    = Create
    | Edit


type alias TalkIdentifier =
    { roundId : String
    , offset : Time
    }


type alias DeleteFormModel =
    { talk : LightningTalk.Model
    , round : Round.Model
    }


type alias Timeslot =
    { round : Round.Model
    , offset : Time
    , model : Maybe LightningTalk.Model
    }


type Model
    = NoData Date
    | Loading Page Data
    | Show Page Data Modifier


type Page
    = UpcomingTalks
    | PreviousTalks
    | CreateEditTalkForm
    | AllHands
    | Admin


type Modifier
    = WithNoSelection
    | WithTimeslotSelected Timeslot
    | WithRoundEditing Round.Model
    | WithDeletePrompt DeleteFormModel
    | WithDeletingPrompt DeleteFormModel (Maybe Http.Error)
    | WithDeletePromptError DeleteFormModel Http.Error
    | WithTalk LightningTalkFormModel FormType
    | WithTalkSubmitting LightningTalkFormModel FormType (Maybe FormError)
    | WithTalkFormError LightningTalkFormModel FormType FormError
    | WithRound ( String, Time )
    | WithRoundFormError ( String, Time ) Http.Error


type Msg
    = NoOp
    | NavigateTo String
    | GoToUpcomingTalks
    | GoToPreviousTalks
    | GoToCreateForm (Maybe TalkIdentifier)
    | GoToEditForm TalkIdentifier
    | GoToAdminPage
    | GoToAllHandsSlidePage
    | DataRetrieved (List Round.Model)
    | DataRetrieveError Http.Error
    | SelectTimeslot Timeslot
    | PromptForTalkDeletion
    | Cancel
    | DeletingTalk
    | DeleteTalkSuccess Round.Model
    | DeleteTalkFail Http.Error
    | UpdateTalkFormModel LightningTalkFormModel
    | CreateTalkSubmit
    | CreateTalkFail Http.Error
    | CreateTalkSuccess Round.Model
    | UpdateRoundCreateFormModel ( String, Time )
    | UpdateTalkSubmit
    | UpdateTalkFail Http.Error
    | UpdateTalkSuccess Round.Model
    | CreateRoundSubmit
    | CreateRoundFail Http.Error
    | CreateRoundSuccess Round.Model
    | SetRoundIsEditing Round.Model
    | UpdateRound Round.Model
    | UpdateRoundSubmit
    | UpdateRoundFail Http.Error
    | UpdateRoundSuccess Round.Model
