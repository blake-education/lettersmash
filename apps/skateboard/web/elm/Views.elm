module Views exposing (..)

import Debug exposing (..)
import Types exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events as Events
import String
import List exposing (length, member)
import Array exposing (fromList, get)
import Json.Encode exposing (string)


colors : List String
colors =
  [ "LightGrey"
  , "#ef476f"
  , "#ffd166"
  , "#06d6a0"
  , "#118ab2"
  , "#773b9c"
  , "#247ba0"
  , "#70c1b3"
  , "#b2dbbf"
  , "#f3ffbd"
  , "#ff1654"
  ]

view : Model -> Html Msg
view model =
  case (log "model.currentPage" model.currentPage) of
    LobbyPage ->
      lobbyView model.games

    GamePage ->
      gameView model

    --SplashPage ->
      --div [] [ Html.App.map SplashMsg SplashView.view ]

    _ ->
        h1 [] [ text "Page not implemented!" ]


gameView : Model -> Html Msg
gameView model =
  div
    [ class "outer"]
    [ div
      [ class "row" ]
      [ flash model ]
    , div
      [ classList
        [ ("row game-over", True)
        , ("hidden", not model.boardState.game_over)
        ]
      ]
      [ div
        [ class "col-md-4" ]
        [ h2 [] [text "Game Over"] ]
      , div
        [ class "col-md-4" ]
        [ button
          [ class "btn btn-primary btn-default", disabled (not model.boardState.game_over), Events.onClick NewBoard ]
          [ text "Play again" ]
        , button
          [ class "btn", disabled (not model.boardState.game_over), Events.onClick BackToLobby ]
          [ text "Back to Lobby" ]
        ]
    ]
    , div
      [ class "row" ]
      [ div
        [ class "board col-md-12" ]
        [ div
          []
          [ h2 [] [text "Game Name"] ]

        , div
          []
          (List.map (boardRow model.candidate) model.boardState.board)
        ]
      ]
    , buttons model
    , div
      [ class "row" ]
      [ div
        [ class "board col-md-12" ]
        [h2
          [ class "candidate" ]
          (List.map candidateLetterView model.candidate)
        ]
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

buttons: Model -> Html Msg
buttons model =
 div
  [ class "row" ]
  [ div
    [ class "col-md-12"]
    [ div
      [ class "form"]
      [ div
        [ class "btn-group"]
        [ button
            [ class "btn btn-default", disabled (hideClear model.candidate), Events.onClick Clear ]
            [ text "Clear" ]
        , button
            [ class "btn btn-default", disabled (hideClear model.candidate), Events.onClick Backspace ]
            [ text "<-" ]
        , button
            [ class "btn btn-primary", disabled (hideSubmit model.candidate), Events.onClick Submit ]
            [ text "Submit" ]
        ]
      ]
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


playerView : Player -> Html msg
playerView player =
  div
    [ ]
    [ playerBadge player]

playerBadge : Player -> Html msg
playerBadge player =
  div
    [class "player", backgroundStyle player.index]
    [ div
      [class "name"]
      [text (player.name ++ " " ++ toString (player.score))]
    , span
      [class "total"]
      [text ("Points: " ++ toString (player.total_score))]
    , span
      [class "total"]
      [text ("Won: " ++ toString (player.games_won))]
    , span
      [class "total"]
      [text ("Played: " ++ toString (player.games_played))]
    ]

wordlistView : Word -> Html msg
wordlistView word  =
  div
    [ backgroundStyle word.played_by ]
    [ h4 [] [ text word.word ] ]


boardRow : Candidate -> BoardRow -> Html Msg
boardRow candidate letters =
  div
    []
    (List.map (letterView candidate) letters)


letterView : Candidate -> Letter -> Html Msg
letterView candidate letter =
  span
    [ classList
      [ ("letter", True)
      , ("surrounded", letter.surrounded)
      , ("selected", (letterSelected letter candidate) == True)
      ]
    , backgroundStyle letter.owner
    , Events.onClick (Select letter)
    ]
    [ text (letter.letter) ]


candidateLetterView : Letter -> Html Msg
candidateLetterView letter =
  span
    [ classList
      [ ("mini letter", True)
      , ("surrounded", letter.surrounded)
      ]
    , backgroundStyle letter.owner
    ]
    [ text (letter.letter) ]


flash : Model -> Html Msg
flash model =
  if String.isEmpty model.errorMessage then
    span [] []
  else
    div
      [ class "col-md-12 alert alert-warning" ]
      [ text model.errorMessage ]


backgroundStyle : Int -> Attribute msg
backgroundStyle index =
  style [ ( "background-color", colourFromList index ) ]

colourFromList : Int -> String
colourFromList index =
  Maybe.withDefault "grey" (get index (fromList colors))

letterSelected : Letter -> Candidate ->  Bool
letterSelected letter candidate =
  List.any (\c -> letter.id == c.id) candidate

lobbyView : List Game -> Html Msg
lobbyView games =
  div []
    [
      h2 [] [text ("Games")]
      , div [] (List.map listGame games)
      , button
        [ class "btn", Events.onClick CreateGame]
        [ text "Create Game" ]
    ]

listGame : Game -> Html Msg
listGame game =
  p
    []
    [ button
        [ class "btn", Events.onClick (JoinGame game.name)]
        --[ class "btn"]
        [text ("Join " ++ toString (game.name))]
    ]
