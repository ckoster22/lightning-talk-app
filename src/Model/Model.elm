module Model.Model exposing (AttributeName, Data, DeleteFormModel, FormError(..), FormType(..), Id, LightningTalkFormModel, Model(..), Modifier(..), Msg(..), Page(..), TalkIdentifier, Timeslot)

import Browser
import Browser.Navigation exposing (Key)
import Dict exposing (Dict)
import Http
import Model.LightningTalkModel as LightningTalk
import Model.RoundModel as Round
import Time exposing (Posix, Zone)
import Url


type alias Data =
    { rounds : List Round.Model
    , initialTime : Posix
    , zone : Zone
    , key : Key
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
    , offsetMs : Int
    }


type alias DeleteFormModel =
    { talk : LightningTalk.Model
    , round : Round.Model
    }


type alias Timeslot =
    { round : Round.Model
    , offsetMs : Int
    , model : Maybe LightningTalk.Model
    }


type Model
    = NoData Key (Maybe Zone) (Maybe Posix)
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
    | WithRound ( String, Posix )
    | WithRoundFormError ( String, Posix ) Http.Error


type Msg
    = NoOp
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url
    | PosixZoneReceived ( Posix, Zone )
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
    | UpdateRoundCreateFormModel ( String, Posix )
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
