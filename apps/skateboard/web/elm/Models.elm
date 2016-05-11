module Models exposing (..)


type alias Status =
  String


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
  , errorMessage = "Welcome to LettersMash"
  }

