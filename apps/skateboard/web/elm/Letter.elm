module Letter (..) where

import Html exposing (..)
import Html.Attributes exposing (..)
import List exposing (reverse, member, length, filter)
import Array exposing (fromList, toList, get)

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
  List Letter


letterSurrounded : Letter -> Bool
letterSurrounded letter =
  if letter.owner == 0 then
    False
  else
    True


letterStyle : Letter -> Attribute
letterStyle letter =
  style [ ( "background-color", letterColour letter ) ]



--if letterSurrounded letter then
--style [ ( "background-color", "#ffff00" ) ]
--else
--style [ ( "background-color", "#aaaa00" ) ]


letterColour : Letter -> String
letterColour letter =
  Maybe.withDefault "grey" (get letter.owner (fromList colors))



--neighbours : Letter -> Board -> List (Maybe Letter)
--neighbours letter board =
--[ above letter board
--, below letter board
--, left letter board
--, right letter board
--]
--protected : Letter -> Board -> Bool
--protected letter board =
--let
--matches =
--filter (\n -> n.owner == letter.owner) (neighbours letter board)
--in
--length matches == 0
--above : Letter -> Board -> Maybe Letter
--above letter board =
--if letter.id < 5 then
--Nothing
--else
--findLetter (letter.id - 5) board
--below : Letter -> Board -> Maybe Letter
--below letter board =
--if letter.id > 19 then
--Nothing
--else
--findLetter (letter.id + 5) board
--right : Letter -> Board -> Maybe Letter
--right letter board =
--if (letter.id % 5) == 4 then
--Nothing
--else
--findLetter (letter.id + 1) board
--left : Letter -> Board -> Maybe Letter
--left letter board =
--if (letter.id % 5) == 0 then
--Nothing
--else
--findLetter (letter.id - 1) board
--findLetter : Int -> Board -> Maybe Letter
--findLetter id board =
--let
--row =
--id `rem` 5
--col =
--id % 5
--b =
--fromList board
--in
--case get col b of
--Just letter ->
--letter
--_ ->
--Nothing
