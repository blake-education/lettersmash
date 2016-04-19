module GameBoard (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
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
  { char :
      String
      --, x : Int
      --, y : Int
  }


type alias Board =
  List Letter


type alias Model =
  { candidate : String
  , board :
      List (List Letter)
  , players : List Player
  }


type Action
  = NoOp
  | Select Letter
  | Submit String
  | Clear
  | UpdateBoard Model


initialModel : Model
initialModel =
  { candidate = ""
  , board =
      [ [ { char = "A" }
        , { char = "G" }
        , { char = "S" }
        , { char = "Z" }
        , { char = "L" }
        ]
      , [ { char = "L" }
        , { char = "B" }
        , { char = "P" }
        , { char = "I" }
        , { char = "U" }
        ]
      , [ { char = "T" }
        , { char = "T" }
        , { char = "D" }
        , { char = "F" }
        , { char = "O" }
        ]
      , [ { char = "C" }
        , { char = "D" }
        , { char = "D" }
        , { char = "G" }
        , { char = "U" }
        ]
      , [ { char = "X" }
        , { char = "D" }
        , { char = "U" }
        , { char = "E" }
        , { char = "R" }
        ]
      ]
  , players =
      [ { name = "martin", score = 10 }
      , { name = "bob", score = 13 }
      , { name = "jane", score = 30 }
      ]
  }



--UPDATE


update : Action -> Model -> Model
update action model =
  case action of
    Submit word ->
      model

    Select letter ->
      { model | candidate = model.candidate ++ letter.char }

    Clear ->
      { model | candidate = "" }

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
        (List.map (boardRow address) model.board)
    , div
        [ class "col-md-4" ]
        (List.map playerView model.players)
    , div
        [ class "col-md-12" ]
        [ button [ Events.onClick address Clear ] [ text "Clear" ]
        , button [ Events.onClick address (Submit model.candidate) ] [ text "Submit" ]
        , h2 [] [ text model.candidate ]
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
