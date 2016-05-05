module GameBoard (..) where

import Models exposing (..)
import Letter exposing (..)
import Task exposing (..)
import Effects exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import String
import List exposing (reverse, member, length, filter)
import Array exposing (fromList, toList, get)
import StartApp as StartApp


app : StartApp.App Model
app =
  StartApp.start
    { init = init
    , update = update
    , view = view
    , inputs = [ incomingActions ]
    }


main : Signal Html
main =
  app.html


port tasks : Signal (Task Never ())
port tasks =
  app.tasks


init : ( Model, Effects Action )
init =
  ( initialModel, Effects.none )


--UPDATE


appendLetter : Letter -> Candidate -> Candidate
appendLetter letter candidate =
  if member letter candidate then
    candidate
  else
    reverse (letter :: reverse candidate)


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    Submit ->
      ( model
      , sendSubmit model.candidate
      )

    Select letter ->
      ( { model | candidate = appendLetter letter model.candidate }
      , Effects.none
      )

    Clear ->
      ( { model |
        candidate = []
        ,errorMessage = "" }
      , Effects.none
      )

    UpdateBoard boardState ->
      ( { model | boardState = boardState }
      , Effects.none
      )

    SubmitSuccess status ->
      ( { model | candidate = [] }
      , Effects.none
      )

    SubmitFailed status ->
      ( { model | errorMessage = "Invalid word" }
      , Effects.none
      )

    _ ->
      ( model
      , Effects.none
      )



--VIEWS


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "row" ]
    [ flash address model
    , div
        []
        [h2 [ class "candidate" ] [ text (List.foldl (\c a -> a ++ c.letter) "" model.candidate) ]]
    , div
        [ class "board col-md-8" ]
        (List.map (boardRow address) model.boardState.board)
    , div
        [ class "col-md-2" ]
        (List.map playerView model.boardState.players)
    , div
        [ class "col-md-2" ]
        (List.map wordlistView model.boardState.wordlist)
    , div
        [ class "col-md-12" ]
        [ button
            [ disabled (hideClear model.candidate), Events.onClick address Clear ]
            [ text "Clear" ]
        , button
            [ disabled (hideSubmit model.candidate), Events.onClick address Submit ]
            [ text "Submit" ]
        ]
    ]


hideSubmit : Candidate -> Bool
hideSubmit candidate =
  length candidate < 4


hideClear : Candidate -> Bool
hideClear candidate =
  length candidate == 0


playerView : Player -> Html
playerView player =
  div
    []
    [ h4 [] [ text (player.name ++ " " ++ toString (player.score)) ] ]


wordlistView : String -> Html
wordlistView word  =
  div
    []
    [ h4 [] [ text word ] ]


boardRow : Signal.Address Action -> BoardRow -> Html
boardRow address letters =
  div
    []
    (List.map (letterView address) letters)

flash : Signal.Address Action -> Model -> Html
flash address model =
  if String.isEmpty model.errorMessage then
    span [] []
  else
    div
      [ class "alert alert-warning"
      ]
      [ text model.errorMessage ]


--SIGNALS
-- submit a word to the server


port submit : Signal Candidate
port submit =
  submitMailbox.signal


submitMailbox : Signal.Mailbox Candidate
submitMailbox =
  Signal.mailbox []



-- incoming ports


port boardState : Signal BoardState
port submitSuccess : Signal String
port submitFailed : Signal String

incomingActions : Signal Action
incomingActions =
  --Signal.map UpdateBoard boardState
  Signal.mergeMany
    [ Signal.map UpdateBoard boardState
    , Signal.map SubmitSuccess submitSuccess
    , Signal.map SubmitFailed submitFailed
    ]


-- EFFECTS


sendSubmit : Candidate -> Effects Action
sendSubmit letters =
  Signal.send submitMailbox.address letters
    |> Effects.task
    |> Effects.map (always NoOp)
