port module GameLobby exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.App as Html
import Html.Events as Events

type alias Game =
  { name : String
  }

type alias GameList = List Game

type alias Model = GameList

initialModel : Model
initialModel = []

main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }

init : ( Model, Cmd Msg )
init =
  ( initialModel, Cmd.none )

view model =
  div []
    (List.map listGame model)

listGame game =
  p
    []
    [ text ("Game Name: " ++ game.name) ]

type Msg
  = NoOp
  | UpdateLobby GameList

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    UpdateLobby gameList ->
      ( gameList
      , Cmd.none
      )

    NoOp ->
      ( model
      , Cmd.none
      )


port gameList : (GameList -> msg) -> Sub msg

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ gameList UpdateLobby
    ]
