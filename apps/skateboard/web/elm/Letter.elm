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
  , "#ef476f"
  , "#ffd166"
  , "#06d6a0"
  , "#118ab2"
  , "#073b4c"
  , "#247ba0"
  , "#70c1b3"
  , "#b2dbbf"
  , "#f3ffbd"
  , "#ff1654"
  ]


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


