port module GameBoard exposing (..)

import Actions exposing (..)
import Models exposing (..)
import Views exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import String
import List exposing (reverse, member, drop)


main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }


init : ( Model, Cmd Msg )
init =
  ( initialModel, Cmd.none )


-- UPDATE


appendLetter : Letter -> Candidate -> Candidate
appendLetter letter candidate =
  if member letter candidate then
    candidate
  else
    reverse (letter :: reverse candidate)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Submit ->
      ( model
      , submit model.candidate
      )

    RequestNewGame ->
      ( model
      , requestNewGame ""
      )


    Select letter ->
      ( { model | candidate = appendLetter letter model.candidate }
      , Cmd.none
      )

    Clear ->
      ( { model |
        candidate = []
        , errorMessage = "" }
      , Cmd.none
      )

    Backspace ->
      ( { model |
        candidate = reverse(drop 1 (reverse model.candidate ))
        ,errorMessage = "" }
      , Cmd.none
      )

    UpdateBoard boardState ->
      ( { model | boardState = boardState }
      , Cmd.none
      )

    SubmitSuccess status ->
      ( { model | candidate = [] }
      , Cmd.none
      )

    SubmitFailed errorMessage ->
      ( { model | errorMessage = errorMessage }
      , Cmd.none
      )

    _ ->
      ( model
      , Cmd.none
      )

-- PORTS

-- outgoing ports

port submit : List Letter -> Cmd msg
port requestNewGame : String -> Cmd msg


-- incoming ports


port boardState : (BoardState -> msg) -> Sub msg
port gameOver : (String -> msg) -> Sub msg
port submitSuccess : (String -> msg) -> Sub msg
port submitFailed : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ boardState UpdateBoard
    , submitSuccess SubmitSuccess
    , submitFailed SubmitFailed
    , gameOver GameOver
    ]

