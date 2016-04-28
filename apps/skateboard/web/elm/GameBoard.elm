module GameBoard (..) where

import Task exposing (..)
import Effects exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import List exposing (reverse, member, length)
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



--MODELS


type alias Player =
  { name : String
  , score : Int
  }


type alias Letter =
  { letter : String
  , id : Int
  }


type alias Board =
  List (List Letter)


type alias Candidate =
  List Letter


type alias BoardState =
  { board : Board
  , players : List Player
  }


type alias Model =
  { candidate : Candidate
  , boardState : BoardState
  }


type Action
  = NoOp
  | Select Letter
  | Submit
  | Clear
  | UpdateBoard BoardState


initialModel : Model
initialModel =
  { candidate = []
  , boardState =
      { board = []
      , players = []
      }
  }


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
      ( { model | candidate = [] }
      , Effects.none
      )

    UpdateBoard boardState ->
      ( { model | boardState = boardState }
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
    [ div
        [ class "jumbotron" ]
        [ h3 [] [ text "LettersMash" ] ]
    , div
        [ class "board col-md-8" ]
        (List.map (boardRow address) model.boardState.board)
    , div
        [ class "col-md-4" ]
        (List.map playerView model.boardState.players)
    , div
        [ class "col-md-12" ]
        [ button
            [ disabled (hideClear model.candidate), Events.onClick address Clear ]
            [ text "Clear" ]
        , button
            [ disabled (hideSubmit model.candidate), Events.onClick address Submit ]
            [ text "Submit" ]
        , h2 [] [ text (List.foldl (\c a -> a ++ c.letter) "" model.candidate) ]
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
    [ h3 [] [ text (player.name ++ " " ++ toString (player.score)) ] ]


boardRow : Signal.Address Action -> List Letter -> Html
boardRow address letters =
  div
    []
    (List.map (letterView address) letters)


letterView : Signal.Address Action -> Letter -> Html
letterView address model =
  span
    [ class "letter", Events.onClick address (Select model), style [ ( "font-size", "150%" ) ] ]
    [ text model.letter ]



--SIGNALS
-- submit a word to the server


port submit : Signal Candidate
port submit =
  submitMailbox.signal


submitMailbox : Signal.Mailbox Candidate
submitMailbox =
  Signal.mailbox []



-- update the state of the board and players


port boardState : Signal BoardState



--port boardState =
--Signal BoardState


incomingActions : Signal Action
incomingActions =
  Signal.map UpdateBoard boardState



-- EFFECTS


sendSubmit : Candidate -> Effects Action
sendSubmit letters =
  Signal.send submitMailbox.address letters
    |> Effects.task
    |> Effects.map (always NoOp)
