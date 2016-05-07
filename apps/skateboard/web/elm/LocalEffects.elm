module LocalEffects (..) where

import Models exposing (Candidate)
import Actions exposing (..)
import Effects exposing (..)


submitMailbox : Signal.Mailbox Candidate
submitMailbox =
  Signal.mailbox []


sendSubmit : Candidate -> Effects Action
sendSubmit letters =
  Signal.send submitMailbox.address letters
    |> Effects.task
    |> Effects.map (always NoOp)


newGameMailbox : Signal.Mailbox String
newGameMailbox =
  Signal.mailbox ""


sendNewGame : String -> Effects Action
sendNewGame message =
  Signal.send newGameMailbox.address message
    |> Effects.task
    |> Effects.map (always NoOp)



