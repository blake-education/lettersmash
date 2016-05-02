module Letter (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import Effects exposing (..)
import Array exposing (fromList, get)

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


type alias Letter =
  { letter : String
  , id : Int
  , owner : Int
  , surrounded : Bool
  }


type alias Player =
  { name : String
  , score : Int
  }


type alias Candidate =
  List Letter


type alias BoardState =
  { board : Board
  , players : List Player
  , wordlist : List String
  }



type alias BoardRow =
  List Letter


type alias Board =
  List BoardRow


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

