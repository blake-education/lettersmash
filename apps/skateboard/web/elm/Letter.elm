module Letter (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Effects exposing (..)
import Array exposing (fromList, get)
import Models exposing (..)

colors : List String
colors =
  [ "LightGrey"
  , "Coral"
  , "CornflowerBlue"
  , "SeaGreen"
  , "MediumRedViolet"
  , "LimeGreen"
  , "Gold"
  , "Peru"
  , "DarkOrange"
  ]


type Action
  = NoOp
  | Select Letter
  | Submit
  | Clear
  | UpdateBoard BoardState
  | SubmitSuccess String
  | SubmitFailed String


letterStyle : Letter -> Attribute
letterStyle letter =
  style [ ( "background-color", letterColour letter ) ]



letterColour : Letter -> String
letterColour letter =
  Maybe.withDefault "grey" (get letter.owner (fromList colors))


letterClass : Letter -> String
letterClass letter =
  if letter.surrounded then
     "letter surrounded"
  else
    "letter"


letterView : Signal.Address Action -> Letter -> Html
letterView address letter =
  span
    [ class(letterClass letter)
    , letterStyle letter
    , Events.onClick address (Select letter)
    ]
    [ text (letter.letter) ]

