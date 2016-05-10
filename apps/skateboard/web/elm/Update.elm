module Update (..) where

import Actions exposing (..)
import Models exposing (..)
import LocalEffects exposing (sendSubmit, sendNewGame)
import String
import List exposing (reverse, member, drop)
import Effects exposing (..)

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

    RequestNewGame ->
      ( model
      , sendNewGame ""
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

    SubmitFailed errorMessage ->
      ( { model | errorMessage = errorMessage }
      , Effects.none
      )

    _ ->
      ( model
      , Effects.none
      )



