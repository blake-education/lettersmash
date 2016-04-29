module Letter (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
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


type alias Letter =
  { letter : String
  , id : Int
  , owner : Int
  }


type alias BoardRow =
  List Letter


type alias Board =
  List BoardRow


letterSurrounded : Letter -> Bool
letterSurrounded letter =
  if letter.owner == 0 then
    False
  else
    True


letterStyle : Letter -> Attribute
letterStyle letter =
  style [ ( "background-color", letterColour letter ) ]



letterColour : Letter -> String
letterColour letter =
  Maybe.withDefault "grey" (get letter.owner (fromList colors))

