module GameBoard (..) where

import Actions exposing (..)
import Models exposing (..)
import Views exposing (..)
import Update exposing (..)
import LocalEffects exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Task exposing (..)
import Effects exposing (..)
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


-- PORTS

-- outgoing ports


port submit : Signal Candidate
port submit =
  submitMailbox.signal

port requestNewGame : Signal String
port requestNewGame =
  newGameMailbox.signal


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

