module Views (..) where

import Actions exposing (..)
import Models exposing (..)
import Letter exposing (..)
import Effects exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import String
import List exposing (length)
import Json.Encode exposing (string)


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ class "outer"]
    [ div
      [ class "row" ]
      [ flash address model
      , div
          [ class "board col-md-12" ]
          (List.map (boardRow address) model.boardState.board)
      ]
    , div
      [ class "row" ]
      [ div
        [ class "col-md-12"]
        [ div
          [ class "form"]
          [ div
            [ class "btn-group"]
            [ button
                [ class "btn btn-default", disabled (hideClear model.candidate), Events.onClick address Clear ]
                [ text "Clear" ]
            , button
                [ class "btn btn-default", disabled (hideClear model.candidate), Events.onClick address Backspace ]
                [ text "<-" ]
            , button
                [ class "btn btn-primary", disabled (hideSubmit model.candidate), Events.onClick address Submit ]
                [ text "Submit" ]
            , button
                [ class "btn btn", disabled (not model.boardState.game_over) ]
                [ text "New Game" ]
            ]
          ]
        ]
      ]
    , div
      [ class "row" ]
      [ div
        [ class "board col-md-12" ]
        [h2 [ class "candidate" ] [ text (List.foldl (\c a -> a ++ c.letter) "" model.candidate) ]]
      ]
    , div
      [ class "row" ]
      [ div
          [ class "col-md-4" ]
          (List.map playerView model.boardState.players)
      , div
          [ class "col-md-8" ]
          (List.map wordlistView model.boardState.wordlist)
      ]
    ]


hideSubmit : Candidate -> Bool
hideSubmit candidate =
  length candidate < 4

hideGameover : BoardState -> Bool
hideGameover boardState =
  not boardState.game_over


hideClear : Candidate -> Bool
hideClear candidate =
  length candidate == 0


playerView : Player -> Html
playerView player =
  div
    []
    [ h4 [] [ text (player.name ++ " " ++ toString (player.score)) ] ]


wordlistView : String -> Html
wordlistView word  =
  div
    []
    [ h4 [] [ text word ] ]


boardRow : Signal.Address Action -> BoardRow -> Html
boardRow address letters =
  div
    []
    (List.map (letterView address) letters)


letterView : Signal.Address Action -> Letter -> Html
letterView address letter =
  span
    [ class(letterClass letter)
    , letterStyle letter
    , Events.onClick address (Select letter)
    ]
    [ text (letter.letter) ]


flash : Signal.Address Action -> Model -> Html
flash address model =
  if String.isEmpty model.errorMessage then
    span [] []
  else
    div
      [ class "alert alert-warning"
      ]
      [ text model.errorMessage ]

