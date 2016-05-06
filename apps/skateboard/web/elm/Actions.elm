module Actions (..) where

import Models exposing (..)

type Action
  = NoOp
  | Select Letter
  | Submit
  | Clear
  | Backspace
  | UpdateBoard BoardState
  | GameOver String
  | SubmitSuccess String
  | SubmitFailed String

