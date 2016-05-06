module GameBoard (..) where

import Actions exposing (..)
import Models exposing (..)
import Views exposing (..)
import Letter exposing (..)
import Task exposing (..)
import Effects exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import String
import List exposing (reverse, member, drop)
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

    Backspace ->
      ( { model |
        candidate = reverse(drop 1 (reverse model.candidate ))
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
port gameOver : Signal String
port submitSuccess : Signal String
port submitFailed : Signal String


incomingActions : Signal Action
incomingActions =
  --Signal.map UpdateBoard boardState
  Signal.mergeMany
    [ Signal.map UpdateBoard boardState
    , Signal.map GameOver gameOver
    , Signal.map SubmitSuccess submitSuccess
    , Signal.map SubmitFailed submitFailed
    ]


-- EFFECTS


sendSubmit : Candidate -> Effects Action
sendSubmit letters =
  Signal.send submitMailbox.address letters
    |> Effects.task
    |> Effects.map (always NoOp)
