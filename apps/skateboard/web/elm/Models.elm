module Models exposing (..)

import Types exposing (..)

type alias Status =
  String


type alias Game =
  { name : String }

type alias Games =
  List Game

type alias Letter =
  { letter : String
  , id : Int
  , owner : Int
  , surrounded : Bool
  }


type alias Player =
  { name : String
  , index : Int
  , score : Int
  , total_score : Int
  , games_played : Int
  , games_won : Int
  }


type alias Candidate =
  List Letter


type alias Word =
  { word : String
  , played_by : Int
  }


type alias BoardState =
  { board : Board
  , players : List Player
  , wordlist : List Word
  , game_over : Bool
  }


type alias BoardRow =
  List Letter


type alias Board =
  List BoardRow


type alias Model =
  { candidate : Candidate
  , boardState : BoardState
  , errorMessage : String
  , currentPage : Page
  , games : Games
  , help : Bool
  }


initialModel : Model
initialModel =
  { candidate = []
  , boardState =
      { board = []
      , players = []
      , wordlist = []
      , game_over = False
      }
  , errorMessage = ""
  , currentPage = LobbyPage
  , games = []
  , help = False
  }

