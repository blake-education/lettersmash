module Actions exposing (..)

import Models exposing (..)

type Msg
  = NoOp
  | GamesList Games
  | CreateGame
  | JoinGame String
  | NewBoard
  | BackToLobby
  | Select Letter
  | Submit
  | Clear
  | Backspace
  | GameOver String
  | SubmitSuccess String
  | SubmitFailed String
  | UpdateBoard BoardState
  | Navigate String

