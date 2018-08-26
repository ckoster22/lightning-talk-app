module Update.Show.Update exposing (update)

import Browser.Navigation as Nav
import Helpers.ModelHelper as ModelHelper
import Http
import Http.RoundHttp exposing (createRound, createTalk, deleteTalk, updateRound, updateTalk)
import Model.LightningTalkModel as LightningTalk
import Model.Model as Model exposing (Data, FormError(..), FormType(..), LightningTalkFormModel, Model(..), Modifier(..), Msg(..), Page(..), TalkIdentifier, Timeslot)
import Model.RoundModel as Round
import Time exposing (Posix)


update : Msg -> Page -> Data -> Modifier -> ( Model, Cmd Msg )
update msg page data modifier =
    case msg of
        Cancel ->
            handleCancel page data

        CreateRoundFail httpError ->
            handleCreateRoundFail page data modifier httpError

        CreateRoundSubmit ->
            handleCreateRoundSubmit page data modifier

        CreateRoundSuccess round ->
            handleCreateRoundSuccess data round

        CreateTalkFail httpError ->
            handleCreateTalkFail page data modifier httpError

        CreateTalkSubmit ->
            handleCreateTalkSubmit page data modifier

        CreateTalkSuccess updatedRound ->
            handleCreateTalkSuccess page data modifier updatedRound

        DeleteTalkFail httpError ->
            handleDeleteTalkFail page data modifier httpError

        DeleteTalkSuccess updatedRound ->
            handleDeleteTalkSuccess page data modifier updatedRound

        DeletingTalk ->
            handleDeletingTalk page data modifier

        GoToCreateForm maybeTalkIdentifier ->
            handleGoToCreateForm data maybeTalkIdentifier

        GoToEditForm talkIdentifier ->
            handleGoToEditForm data talkIdentifier

        GoToPreviousTalks ->
            handleGoToTalksPage PreviousTalks data modifier

        GoToUpcomingTalks ->
            handleGoToTalksPage UpcomingTalks data modifier

        NavigateTo route ->
            ( Show page data modifier
            , Nav.pushUrl data.key route
            )

        PromptForTalkDeletion ->
            handlePromptForTalkDeletion page data modifier

        SelectTimeslot timeslot ->
            handleSelectTimeslot timeslot page data

        SetRoundIsEditing round ->
            handleSetRoundIsEditing page data modifier round

        UpdateRound round ->
            handleUpdateRound page data round

        UpdateRoundCreateFormModel formModel ->
            handleUpdateRoundCreateFormModel page data modifier formModel

        UpdateRoundSubmit ->
            handleUpdateRoundSubmit page data modifier

        UpdateRoundSuccess updatedRound ->
            handleUpdateRoundSuccess page data modifier updatedRound

        UpdateTalkFormModel updatedTalkFormModel ->
            handleUpdateTalkFormModel page data modifier updatedTalkFormModel

        UpdateTalkFail httpError ->
            handleUpdateTalkFail page data modifier httpError

        UpdateTalkSubmit ->
            handleUpdateTalkSubmit page data modifier

        UpdateTalkSuccess updatedRound ->
            handleUpdateTalkSuccess page data modifier updatedRound

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


getValidationError : LightningTalkFormModel -> Maybe FormError
getValidationError talkFormModel =
    let
        descriptionError =
            if talkFormModel.model.description == "" then
                [ "description" ]

            else
                []

        speakersError =
            if talkFormModel.model.speakers == "" then
                [ "speakers" ]

            else
                []

        timeslotError =
            if talkFormModel.selectedSlotNum == Nothing then
                [ "timeslot" ]

            else
                []

        topicError =
            if talkFormModel.model.topic == "" then
                [ "topic" ]

            else
                []

        allErrors =
            List.concat (descriptionError :: speakersError :: timeslotError :: topicError :: [])
    in
    if List.length allErrors > 0 then
        Just (ValidationError allErrors)

    else
        Nothing


handleCancel : Page -> Data -> ( Model, Cmd Msg )
handleCancel page data =
    if page == PreviousTalks then
        ( Show PreviousTalks data WithNoSelection
        , Cmd.none
        )

    else
        ( Show UpcomingTalks data WithNoSelection
        , Cmd.none
        )


handleCreateRoundFail : Page -> Data -> Modifier -> Http.Error -> ( Model, Cmd Msg )
handleCreateRoundFail page data modifier httpError =
    case ( page, modifier ) of
        ( Admin, WithRound formModel ) ->
            ( Show Admin data (WithRoundFormError formModel httpError)
            , Cmd.none
            )

        ( Admin, WithRoundFormError formModel _ ) ->
            ( Show Admin data (WithRoundFormError formModel httpError)
            , Cmd.none
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleCreateRoundSubmit : Page -> Data -> Modifier -> ( Model, Cmd Msg )
handleCreateRoundSubmit page data modifier =
    case ( page, modifier ) of
        ( Admin, WithRound ( theme, startTime ) ) ->
            let
                round =
                    Round.Model "" startTime theme Nothing Nothing Nothing Nothing
            in
            ( Show page data modifier
            , createRound round
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleCreateRoundSuccess : Data -> Round.Model -> ( Model, Cmd Msg )
handleCreateRoundSuccess data newRound =
    let
        nextRounds =
            newRound :: data.rounds

        nextData =
            { data | rounds = nextRounds }
    in
    ( Show UpcomingTalks nextData WithNoSelection
    , Cmd.none
    )


handleCreateTalkFail : Page -> Data -> Modifier -> Http.Error -> ( Model, Cmd Msg )
handleCreateTalkFail page data modifier httpError =
    case modifier of
        WithTalkSubmitting formModel formType _ ->
            ( Show page data (WithTalkFormError formModel formType (AsyncError httpError))
            , Cmd.none
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleCreateTalkSubmit : Page -> Data -> Modifier -> ( Model, Cmd Msg )
handleCreateTalkSubmit page data modifier =
    case modifier of
        WithTalk talkFormModel formType ->
            handleTalkSubmit data talkFormModel formType

        WithTalkFormError talkFormModel formType _ ->
            handleTalkSubmit data talkFormModel formType

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleCreateTalkSuccess : Page -> Data -> Modifier -> Round.Model -> ( Model, Cmd Msg )
handleCreateTalkSuccess page data modifier updatedRound =
    let
        nextRounds =
            List.map
                (\round ->
                    if round.id == updatedRound.id then
                        updatedRound

                    else
                        round
                )
                data.rounds

        nextData =
            { data | rounds = nextRounds }
    in
    case ( page, modifier ) of
        ( CreateEditTalkForm, WithTalkSubmitting _ _ _ ) ->
            ( Show UpcomingTalks nextData WithNoSelection
            , Nav.pushUrl data.key "/#upcoming"
            )

        _ ->
            ( Show page nextData modifier
            , Cmd.none
            )


handleDeleteTalkFail : Page -> Data -> Modifier -> Http.Error -> ( Model, Cmd Msg )
handleDeleteTalkFail page data modifier httpError =
    case modifier of
        WithDeletingPrompt talk _ ->
            ( Show page data (WithDeletePromptError talk httpError)
            , Cmd.none
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleDeleteTalkSuccess : Page -> Data -> Modifier -> Round.Model -> ( Model, Cmd Msg )
handleDeleteTalkSuccess page data modifier updatedRound =
    let
        nextRounds =
            List.map
                (\round ->
                    if round.id == updatedRound.id then
                        updatedRound

                    else
                        round
                )
                data.rounds

        nextData =
            { data | rounds = nextRounds }
    in
    case ( page, modifier ) of
        ( UpcomingTalks, WithDeletingPrompt _ _ ) ->
            ( Show UpcomingTalks nextData WithNoSelection
            , Cmd.none
            )

        _ ->
            ( Show page nextData modifier
            , Cmd.none
            )


handleDeletingTalk : Page -> Data -> Modifier -> ( Model, Cmd Msg )
handleDeletingTalk page data modifier =
    case modifier of
        WithDeletePrompt deleteFormModel ->
            let
                round =
                    deleteFormModel.round

                nextRound =
                    if round.slot1 == Just deleteFormModel.talk then
                        { round | slot1 = Nothing }

                    else if round.slot2 == Just deleteFormModel.talk then
                        { round | slot2 = Nothing }

                    else if round.slot3 == Just deleteFormModel.talk then
                        { round | slot3 = Nothing }

                    else if round.slot4 == Just deleteFormModel.talk then
                        { round | slot4 = Nothing }

                    else
                        round
            in
            ( Show UpcomingTalks data (WithDeletingPrompt deleteFormModel Nothing)
            , deleteTalk nextRound
            )

        WithDeletePromptError deleteFormModel httpError ->
            let
                round =
                    deleteFormModel.round

                nextRound =
                    if round.slot1 == Just deleteFormModel.talk then
                        { round | slot1 = Nothing }

                    else if round.slot2 == Just deleteFormModel.talk then
                        { round | slot2 = Nothing }

                    else if round.slot3 == Just deleteFormModel.talk then
                        { round | slot3 = Nothing }

                    else if round.slot4 == Just deleteFormModel.talk then
                        { round | slot4 = Nothing }

                    else
                        round
            in
            ( Show UpcomingTalks data (WithDeletingPrompt deleteFormModel (Just httpError))
            , deleteTalk nextRound
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleGoToCreateForm : Data -> Maybe TalkIdentifier -> ( Model, Cmd Msg )
handleGoToCreateForm data maybeTalkIdentifier =
    let
        formModel =
            case maybeTalkIdentifier of
                Just { roundId, offsetMs } ->
                    let
                        maybeSelectedRound =
                            data.rounds
                                |> List.filter (\round -> round.id == roundId)
                                |> List.head

                        selectedSlotNum =
                            if offsetMs == 0 then
                                1

                            else if offsetMs == 600000 then
                                2

                            else if offsetMs == 1200000 then
                                3

                            else
                                4
                    in
                    { original = LightningTalk.empty, model = LightningTalk.empty, selectedRound = maybeSelectedRound, selectedSlotNum = Just selectedSlotNum }

                Nothing ->
                    let
                        original =
                            LightningTalk.empty

                        selectedRound =
                            data.rounds
                                |> List.filter (\round -> Time.posixToMillis data.initialTime < Time.posixToMillis round.startDateTime)
                                |> List.head
                    in
                    { original = original, model = original, selectedRound = selectedRound, selectedSlotNum = Nothing }
    in
    ( Show CreateEditTalkForm data (WithTalk formModel Create)
    , Cmd.none
    )


handleGoToEditForm : Data -> TalkIdentifier -> ( Model, Cmd Msg )
handleGoToEditForm data talkIdentifier =
    let
        maybeEditTalk =
            ModelHelper.findTalk data talkIdentifier.roundId talkIdentifier.offsetMs
    in
    case maybeEditTalk of
        Just talk ->
            let
                selectedRound =
                    ModelHelper.getRoundForTalk data talk

                selectedSlotNum =
                    ModelHelper.getSlotNum selectedRound talk

                formModel =
                    { original = talk, model = talk, selectedRound = selectedRound, selectedSlotNum = selectedSlotNum }
            in
            ( Show CreateEditTalkForm data (WithTalk formModel Edit)
            , Cmd.none
            )

        Nothing ->
            let
                formModel =
                    { original = LightningTalk.empty, model = LightningTalk.empty, selectedRound = Nothing, selectedSlotNum = Nothing }
            in
            ( Show CreateEditTalkForm data (WithTalkFormError formModel Edit TalkNotFoundError)
            , Cmd.none
            )


handleGoToTalksPage : Page -> Data -> Modifier -> ( Model, Cmd Msg )
handleGoToTalksPage page data _ =
    let
        maybeSelectedTimeslot =
            ModelHelper.getFirstTimeslotWithTalkOnPage data page

        modifier =
            case maybeSelectedTimeslot of
                Just timeslot ->
                    WithTimeslotSelected timeslot

                Nothing ->
                    WithNoSelection
    in
    ( Show page data modifier
    , Cmd.none
    )


handlePromptForTalkDeletion : Page -> Data -> Modifier -> ( Model, Cmd Msg )
handlePromptForTalkDeletion page data modifier =
    case modifier of
        WithTimeslotSelected selectedTimeslot ->
            let
                selectedLightningTalk =
                    selectedTimeslot.model
                        |> Maybe.withDefault LightningTalk.empty
            in
            ( Show UpcomingTalks data (WithDeletePrompt { talk = selectedLightningTalk, round = selectedTimeslot.round })
            , Cmd.none
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleSelectTimeslot : Timeslot -> Page -> Data -> ( Model, Cmd Msg )
handleSelectTimeslot timeslot page data =
    if page == UpcomingTalks then
        ( Show UpcomingTalks data (WithTimeslotSelected timeslot)
        , Cmd.none
        )

    else
        ( Show PreviousTalks data (WithTimeslotSelected timeslot)
        , Cmd.none
        )


handleSetRoundIsEditing : Page -> Data -> Modifier -> Round.Model -> ( Model, Cmd Msg )
handleSetRoundIsEditing page data modifier round =
    if page == UpcomingTalks then
        ( Show page data (WithRoundEditing round)
        , Cmd.none
        )

    else
        ( Show page data modifier
        , Cmd.none
        )


handleUpdateRound : Page -> Data -> Round.Model -> ( Model, Cmd Msg )
handleUpdateRound page data updatedRound =
    ( Show page data (WithRoundEditing updatedRound)
    , Cmd.none
    )


handleUpdateRoundCreateFormModel : Page -> Data -> Modifier -> ( String, Posix ) -> ( Model, Cmd Msg )
handleUpdateRoundCreateFormModel page data modifier formModel =
    case ( page, modifier ) of
        ( Admin, WithRound _ ) ->
            ( Show Admin data (WithRound formModel)
            , Cmd.none
            )

        ( Admin, WithRoundFormError _ error ) ->
            ( Show Admin data (WithRoundFormError formModel error)
            , Cmd.none
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleUpdateRoundSubmit : Page -> Data -> Modifier -> ( Model, Cmd Msg )
handleUpdateRoundSubmit page data modifier =
    case modifier of
        WithRoundEditing round ->
            ( Show page data modifier
            , updateRound round
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleUpdateRoundSuccess : Page -> Data -> Modifier -> Round.Model -> ( Model, Cmd Msg )
handleUpdateRoundSuccess page data modifier updatedRound =
    case modifier of
        WithRoundEditing _ ->
            let
                nextRounds =
                    List.map
                        (\round ->
                            if round.id == updatedRound.id then
                                updatedRound

                            else
                                round
                        )
                        data.rounds

                nextData =
                    { data | rounds = nextRounds }
            in
            ( Show page nextData WithNoSelection
            , Cmd.none
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleTalkSubmit : Data -> LightningTalkFormModel -> FormType -> ( Model, Cmd Msg )
handleTalkSubmit data talkFormModel formType =
    let
        maybeFormError =
            getValidationError talkFormModel
    in
    case maybeFormError of
        Just formError ->
            ( Show CreateEditTalkForm data (WithTalkFormError talkFormModel formType formError)
            , Cmd.none
            )

        Nothing ->
            let
                maybeOriginalRound =
                    ModelHelper.getRoundForTalk data talkFormModel.original

                cmd =
                    case talkFormModel.selectedRound of
                        Just round ->
                            let
                                updateOriginalRoundCmd =
                                    case ( formType, maybeOriginalRound ) of
                                        ( Edit, Just originalRound ) ->
                                            if originalRound /= round then
                                                updateTalk <| ModelHelper.getRoundMinusThisTalk originalRound talkFormModel.original

                                            else
                                                Cmd.none

                                        _ ->
                                            Cmd.none

                                roundWithoutTalk =
                                    ModelHelper.getRoundMinusThisTalk round talkFormModel.original

                                updatedRound =
                                    case talkFormModel.selectedSlotNum of
                                        Just slotNum ->
                                            if slotNum == 1 then
                                                { roundWithoutTalk | slot1 = Just talkFormModel.model }

                                            else if slotNum == 2 then
                                                { roundWithoutTalk | slot2 = Just talkFormModel.model }

                                            else if slotNum == 3 then
                                                { roundWithoutTalk | slot3 = Just talkFormModel.model }

                                            else if slotNum == 4 then
                                                { roundWithoutTalk | slot4 = Just talkFormModel.model }

                                            else
                                                roundWithoutTalk

                                        Nothing ->
                                            round
                            in
                            case formType of
                                Create ->
                                    createTalk updatedRound

                                Edit ->
                                    Cmd.batch
                                        [ updateTalk updatedRound
                                        , updateOriginalRoundCmd
                                        ]

                        Nothing ->
                            Cmd.none
            in
            ( Show CreateEditTalkForm data (WithTalkSubmitting talkFormModel formType Nothing)
            , cmd
            )


handleUpdateTalkFormModel : Page -> Data -> Modifier -> LightningTalkFormModel -> ( Model, Cmd Msg )
handleUpdateTalkFormModel page data modifier updatedTalkFormModel =
    case modifier of
        WithTalk _ formType ->
            ( Show page data (WithTalk updatedTalkFormModel formType)
            , Cmd.none
            )

        WithTalkFormError _ formType formError ->
            ( Show page data (WithTalkFormError updatedTalkFormModel formType formError)
            , Cmd.none
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleUpdateTalkFail : Page -> Data -> Modifier -> Http.Error -> ( Model, Cmd Msg )
handleUpdateTalkFail page data modifier httpError =
    case modifier of
        WithTalkSubmitting formModel formType _ ->
            ( Show page data (WithTalkFormError formModel formType (AsyncError httpError))
            , Cmd.none
            )

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleUpdateTalkSubmit : Page -> Data -> Modifier -> ( Model, Cmd Msg )
handleUpdateTalkSubmit page data modifier =
    case modifier of
        WithTalk talkFormModel formType ->
            handleTalkSubmit data talkFormModel formType

        WithTalkFormError talkFormModel formType _ ->
            handleTalkSubmit data talkFormModel formType

        _ ->
            ( Show page data modifier
            , Cmd.none
            )


handleUpdateTalkSuccess : Page -> Data -> Modifier -> Round.Model -> ( Model, Cmd Msg )
handleUpdateTalkSuccess page data modifier updatedRound =
    let
        nextRounds =
            List.map
                (\round ->
                    if round.id == updatedRound.id then
                        updatedRound

                    else
                        round
                )
                data.rounds

        nextData =
            { data | rounds = nextRounds }
    in
    case ( page, modifier ) of
        ( CreateEditTalkForm, WithTalkSubmitting _ _ _ ) ->
            ( Show UpcomingTalks nextData WithNoSelection
            , Nav.pushUrl data.key "/#upcoming"
            )

        _ ->
            ( Show page nextData modifier
            , Cmd.none
            )
