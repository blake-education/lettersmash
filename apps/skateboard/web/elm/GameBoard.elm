module GameBoard (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import List exposing (reverse, member)
import StartApp.Simple


main : Signal.Signal Html
main =
  StartApp.Simple.start
    { model = initialModel
    , view = view
    , update = update
    }



--MODELS


type alias Player =
  { name : String
  , score : Int
  }


type alias Letter =
  { char : String
  , id: Int
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
  | Submit Candidate
  | Clear
  | UpdateBoard Model


initialModel : Model
initialModel =
  { candidate = []
  , boardState = {
      board =
      [ [ { char = "A", id = 0 }
        , { char = "G", id = 1 }
        , { char = "S", id = 2 }
        , { char = "Z", id = 3 }
        , { char = "L", id = 4 }
        ]
      , [ { char = "L", id = 5 }
        , { char = "B", id = 6 }
        , { char = "P", id = 7 }
        , { char = "I", id = 8 }
        , { char = "U", id = 9 }
        ]
      , [ { char = "T", id = 10 }
        , { char = "T", id = 11 }
        , { char = "D", id = 12 }
        , { char = "F", id = 13 }
        , { char = "O", id = 14 }
        ]
      , [ { char = "C", id = 15 }
        , { char = "D", id = 16 }
        , { char = "D", id = 17 }
        , { char = "G", id = 18 }
        , { char = "U", id = 19 }
        ]
      , [ { char = "X", id = 20 }
        , { char = "D", id = 21 }
        , { char = "U", id = 22 }
        , { char = "E", id = 23 }
        , { char = "R", id = 24 }
        ]
      ]
    , players =
      [ { name = "martin", score = 10 }
      , { name = "bob", score = 13 }
      , { name = "jane", score = 30 }
      ]
    }
  }



--UPDATE
appendLetter : Letter -> Candidate -> Candidate
appendLetter letter candidate =
  if member letter candidate then
    candidate
  else
    reverse (letter :: reverse candidate)

update : Action -> Model -> Model
update action model =
  case action of
    Submit word ->
      model

    Select letter ->
      { model | candidate = appendLetter letter model.candidate }

    Clear ->
      { model | candidate = [] }

    _ ->
      model



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
        [ button [ Events.onClick address Clear ] [ text "Clear" ]
        , button [ Events.onClick address (Submit model.candidate) ] [ text "Submit" ]
        , h2 [] [ text (List.foldl (\c a -> a ++ c.char) "" model.candidate) ]
        ]
    ]


playerView : Player -> Html
playerView player =
  div
    []
    [ h3 [] [ text player.name ] ]


boardRow : Signal.Address Action -> List Letter -> Html
boardRow address letters =
  div
    []
    (List.map (letterView address) letters)


letterView : Signal.Address Action -> Letter -> Html
letterView address model =
  span
    [ class "letter", Events.onClick address (Select model), style [ ( "font-size", "150%" ) ] ]
    [ text model.char ]



--SIGNALS
