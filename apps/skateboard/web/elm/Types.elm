module Types exposing (..)

type Page
  = LobbyPage
  | GamePage
  | NotImplementedPage

type Msg
  = NoOp
  | GamesList Games
  | CreateGame
  | JoinGame String
  | NewBoard
  | BackToLobby
  | LeaveGame
  | Select Letter
  | Submit
  | Clear
  | Backspace
  | GameOver String
  | SubmitSuccess String
  | SubmitFailed String
  | UpdateBoard BoardState
  | Navigate String
