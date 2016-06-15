port module GameBoard exposing (..)

import Debug exposing (..)
import Types exposing (..)
import Actions exposing (..)
import Models exposing (..)
import Views exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import String
import List exposing (reverse, member, drop)
import Navigation exposing (..)


main =
  Navigation.program urlParser
    { init = init
    , update = update
    , view = view
    , urlUpdate = urlUpdate
    , subscriptions = subscriptions
    }


init : String -> ( Model, Cmd Msg )
init url =
  urlUpdate url initialModel


-- UPDATE


appendLetter : Letter -> Candidate -> Candidate
appendLetter letter candidate =
  if member letter candidate then
    candidate
  else
    reverse (letter :: reverse candidate)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Navigate url ->
      ( model
      , newUrl url
      )

    BackToLobby ->
      ( model
      , newUrl "/#/lobby"
      )

    LeaveGame ->
      ( model
      , leaveGame ""
      )

    GamesList games ->
      ( { model | games = games }
      , Cmd.none
      )

    NewBoard ->
      ( model
      , newBoard ""
      )

    JoinGame gameName ->
      ( model
      , joinGame gameName
      )

    CreateGame ->
      ( model
      , newGame "test"
      )

    UpdateBoard boardState ->
      ( { model | boardState = boardState }
      , Cmd.none
      )

    Select letter ->
      ( { model | candidate = appendLetter letter model.candidate }
      , Cmd.none
      )

    Clear ->
      ( { model |
        candidate = []
        , errorMessage = "" }
      , Cmd.none
      )

    Backspace ->
      ( { model |
        candidate = reverse(drop 1 (reverse model.candidate ))
        ,errorMessage = "" }
      , Cmd.none
      )

    Submit ->
      ( model
      , submit model.candidate
      )

    SubmitSuccess status ->
      ( { model | candidate = [] }
      , Cmd.none
      )

    SubmitFailed errorMessage ->
      ( { model | errorMessage = errorMessage }
      , Cmd.none
      )

    _ ->
      ( model
      , Cmd.none
      )

-- PORTS

-- outgoing ports

port newGame : String -> Cmd msg
port joinGame : String -> Cmd msg
port newBoard : String -> Cmd msg
port submit : List Letter -> Cmd msg
port leaveGame : String -> Cmd msg


-- incoming ports


port games : (List Game -> msg) -> Sub msg
port boardState : (BoardState -> msg) -> Sub msg
port gameOver : (String -> msg) -> Sub msg
port submitSuccess : (String -> msg) -> Sub msg
port submitFailed : (String -> msg) -> Sub msg
port navigate : (String -> msg) -> Sub msg


subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ boardState UpdateBoard
    , submitSuccess SubmitSuccess
    , submitFailed SubmitFailed
    , gameOver GameOver
    , games GamesList
    , navigate Navigate
    ]

urlUpdate : String -> Model -> ( Model, Cmd Msg )
urlUpdate url model =
    if (log "url" url) == "game" then
        ( { model | currentPage = GamePage }, Cmd.none )
    else
        ( { model | currentPage = LobbyPage }, Cmd.none )



-- URL PARSERS - check out evancz/url-parser for fancier URL parsing


fromUrl : String -> String
fromUrl url =
    String.dropLeft 2 url


urlParser : Navigation.Parser String
urlParser =
    Navigation.makeParser (fromUrl << .hash)
