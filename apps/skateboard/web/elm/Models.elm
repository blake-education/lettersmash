module Models (..) where


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
  , score : Int
  }


type alias Candidate =
  List Letter


type alias BoardState =
  { board : Board
  , players : List Player
  , wordlist : List String
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

