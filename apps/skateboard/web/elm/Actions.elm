module Actions exposing (..)

import Models exposing (..)

type Msg
  = NoOp
  | Select Letter
  | Submit
  | Clear
  | Backspace
  | UpdateBoard BoardState
  | GameOver String
  | SubmitSuccess String
  | SubmitFailed String
  | RequestNewGame

