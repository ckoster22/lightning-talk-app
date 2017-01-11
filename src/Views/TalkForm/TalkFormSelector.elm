module Views.TalkForm.TalkFormSelector exposing (selector, RoundViewModel, TimeslotViewModel, ViewModel)

import Model.Model exposing (Data, FormError(..), FormType(..), LightningTalkFormModel, Modifier(..), Msg(..))
import Model.LightningTalkModel as LightningTalk
import Model.RoundModel as Round
import Helpers.DateHelper as DateHelper
import Helpers.ErrorHandling as ErrorHandling
import Helpers.ModelHelper as ModelHelper
import Date exposing (Date)


type alias ViewModel =
    { generalError : Maybe String
    , upcomingRounds : List RoundViewModel
    , formModel : LightningTalkFormModel
    , selectedRound : Maybe RoundViewModel
    , hasTimeslotError : Bool
    , hasTopicError : Bool
    , hasSpeakersError : Bool
    , hasDescriptionError : Bool
    , onTopicChange : String -> Msg
    , onSpeakersChange : String -> Msg
    , onRoundChange : String -> Msg
    , onDescriptionChange : String -> Msg
    , submit : SubmitModel
    }


type alias SubmitModel =
    { label : String
    , isDisabled : Bool
    , onSubmit : Msg
    }


type alias RoundViewModel =
    { round : Round.Model
    , displayText : String
    , isSelected : Bool
    , isFull : Bool
    , slots : List TimeslotViewModel
    }


type alias TimeslotViewModel =
    { timeslotId : String
    , isChecked : Bool
    , isDisabled : Bool
    , onCheckedHandler : Bool -> Msg
    , timeDisplay : String
    }


emptyFormModel : LightningTalkFormModel
emptyFormModel =
    { original = LightningTalk.empty, model = LightningTalk.empty, selectedRound = Nothing, selectedSlotNum = Nothing }


selector : Data -> Modifier -> ViewModel
selector data modifier =
    let
        ( formModel, maybeFormError ) =
            case modifier of
                WithTalk talkFormModel _ ->
                    ( talkFormModel, Nothing )

                WithTalkSubmitting talkFormModel _ maybeError ->
                    ( talkFormModel, maybeError )

                WithTalkFormError talkFormModel _ formError ->
                    ( talkFormModel, Just formError )

                _ ->
                    ( emptyFormModel, Nothing )

        upcomingRounds =
            data.rounds
                |> List.filter (\round -> Date.toTime data.initialTime < round.startDateTime)

        selectedRound =
            case formModel.selectedRound of
                Just selectedRound ->
                    Just <| createRoundViewModel formModel selectedRound

                Nothing ->
                    Nothing

        upcomingRoundViewModels =
            List.map (createRoundViewModel formModel) upcomingRounds

        maybeGeneralError =
            case maybeFormError of
                Just (AsyncError httpError) ->
                    Just (ErrorHandling.getMessageFromError httpError)

                Just TalkNotFoundError ->
                    Just "This Lightning Talk does not exist!"

                _ ->
                    Nothing

        hasTimeslotError =
            hasErrorForField maybeFormError "timeslot"

        hasTopicError =
            hasErrorForField maybeFormError "topic"

        hasSpeakersError =
            hasErrorForField maybeFormError "speakers"

        hasDescriptionError =
            hasErrorForField maybeFormError "description"

        onTopicChange =
            onTopicUpdate formModel

        onSpeakersChange =
            onSpeakersUpdate formModel

        onRoundChange =
            onRoundUpdate formModel data.rounds

        onDescriptionChange =
            onDescriptionUpdate formModel

        submitModel =
            createSubmitModel modifier
    in
        ViewModel
            maybeGeneralError
            upcomingRoundViewModels
            formModel
            selectedRound
            hasTimeslotError
            hasTopicError
            hasSpeakersError
            hasDescriptionError
            onTopicChange
            onSpeakersChange
            onRoundChange
            onDescriptionChange
            submitModel


hasErrorForField : Maybe FormError -> String -> Bool
hasErrorForField maybeFormError fieldName =
    case maybeFormError of
        Just (ValidationError errorAttributes) ->
            List.member fieldName errorAttributes

        _ ->
            False


onTopicUpdate : LightningTalkFormModel -> String -> Msg
onTopicUpdate formModel topic =
    let
        currTalk =
            formModel.model

        nextTalk =
            { currTalk | topic = topic }
    in
        UpdateTalkFormModel { formModel | model = nextTalk }


onSpeakersUpdate : LightningTalkFormModel -> String -> Msg
onSpeakersUpdate formModel speakers =
    let
        currTalk =
            formModel.model

        nextTalk =
            { currTalk | speakers = speakers }
    in
        UpdateTalkFormModel { formModel | model = nextTalk }


onRoundUpdate : LightningTalkFormModel -> List Round.Model -> String -> Msg
onRoundUpdate formModel rounds roundId =
    let
        nextRound =
            rounds
                |> List.filter (\round -> round.id == roundId)
                |> List.head
    in
        UpdateTalkFormModel { formModel | selectedRound = nextRound, selectedSlotNum = Nothing }


onDescriptionUpdate : LightningTalkFormModel -> String -> Msg
onDescriptionUpdate formModel description =
    let
        currTalk =
            formModel.model

        nextTalk =
            { currTalk | description = description }
    in
        UpdateTalkFormModel { formModel | model = nextTalk }


createRoundViewModel : LightningTalkFormModel -> Round.Model -> RoundViewModel
createRoundViewModel formModel round =
    let
        isSelected =
            case formModel.selectedRound of
                Just selectedRound ->
                    selectedRound.id == round.id

                Nothing ->
                    False

        theme =
            ModelHelper.getThemeDisplay round.theme

        displayText =
            (DateHelper.getDateFromEpoch round.startDateTime) ++ " - " ++ theme

        isFull =
            round.slot1 /= Nothing && round.slot2 /= Nothing && round.slot3 /= Nothing && round.slot4 /= Nothing

        timeslotViewModels =
            [ createTimeslotViewModel formModel round round.slot1 1
            , createTimeslotViewModel formModel round round.slot1 2
            , createTimeslotViewModel formModel round round.slot1 3
            , createTimeslotViewModel formModel round round.slot1 4
            ]
    in
        RoundViewModel round displayText isSelected isFull timeslotViewModels


createTimeslotViewModel : LightningTalkFormModel -> Round.Model -> Maybe LightningTalk.Model -> Int -> TimeslotViewModel
createTimeslotViewModel formModel slotRound maybeTalk slotNum =
    let
        timeslotId =
            "timeslot" ++ (toString slotNum)

        isChecked =
            formModel.selectedRound == Just slotRound && formModel.selectedSlotNum == Just slotNum

        isDisabled =
            if slotNum == 1 then
                slotRound.slot1 /= Nothing && slotRound.slot1 /= Just formModel.original
            else if slotNum == 2 then
                slotRound.slot2 /= Nothing && slotRound.slot2 /= Just formModel.original
            else if slotNum == 3 then
                slotRound.slot3 /= Nothing && slotRound.slot3 /= Just formModel.original
            else
                slotRound.slot4 /= Nothing && slotRound.slot4 /= Just formModel.original

        onCheckedHandler =
            (\checked ->
                if checked then
                    UpdateTalkFormModel { formModel | selectedSlotNum = Just slotNum }
                else
                    UpdateTalkFormModel { formModel | selectedSlotNum = Nothing }
            )

        timeDisplay =
            ModelHelper.getTalkStartTime (slotRound.startDateTime + (((toFloat slotNum) - 1) * 600000))
    in
        TimeslotViewModel timeslotId isChecked isDisabled onCheckedHandler timeDisplay


createSubmitModel : Modifier -> SubmitModel
createSubmitModel modifier =
    case modifier of
        WithTalk _ Create ->
            SubmitModel "Create" False CreateTalkSubmit

        WithTalkSubmitting _ _ _ ->
            SubmitModel "" True NoOp

        WithTalkFormError _ Create _ ->
            SubmitModel "Create" False CreateTalkSubmit

        WithTalk _ Edit ->
            SubmitModel "Update" False UpdateTalkSubmit

        WithTalkFormError _ Edit _ ->
            SubmitModel "Update" False UpdateTalkSubmit

        _ ->
            SubmitModel "Update" True NoOp
