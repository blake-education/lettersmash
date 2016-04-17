module GameBoard (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import StartApp.Simple


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
  , board : List Letter
  }


type Action
  = NoOp
  | Submit
  | Select Letter


initialModel : Model
initialModel =
  { candidate = ""
  , board =
      [ { char = "A" }
      , { char = "B" }
      , { char = "D" }
      , { char = "F" }
      , { char = "U" }
      , { char = "O" }
      , { char = "K" }
      , { char = "N" }
      , { char = "M" }
      , { char = "P" }
      , { char = "J" }
      , { char = "R" }
      , { char = "S" }
      , { char = "E" }
      , { char = "H" }
      , { char = "H" }
      , { char = "M" }
      , { char = "L" }
      , { char = "L" }
      ]
  }


update : Action -> Model -> Model
update action model =
  case action of
    Submit ->
      model

    Select letter ->
      { model | candidate = model.candidate ++ letter.char }

    _ ->
      model


view : Signal.Address Action -> Model -> Html
view address model =
  div
    []
    [ h2 [] [ text model.candidate ]
    , div
        []
        (List.map (letterView address) model.board)
    ]


letterView : Signal.Address Action -> Letter -> Html
letterView address model =
  span
    [ Events.onClick address (Select model), style [ ( "font-size", "150%" ) ] ]
    [ text model.char ]


main : Signal.Signal Html
main =
  StartApp.Simple.start
    { model = initialModel
    , view = view
    , update = update
    }
