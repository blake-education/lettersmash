// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"

const initialState = {
    boardState:
    {
        board:
          [ [
            { letter : "M", id : 0 }
            , { letter : "U", id : 1 }
            , { letter : "S", id : 2 }
            , { letter : "Z", id : 3 }
            , { letter : "L", id : 4 }
            ]
          , [ { letter : "L", id : 5 }
            , { letter : "B", id : 6 }
            , { letter : "P", id : 7 }
            , { letter : "I", id : 8 }
            , { letter : "U", id : 9 }
            ]
          , [ { letter : "T", id : 10 }
            , { letter : "T", id : 11 }
            , { letter : "D", id : 12 }
            , { letter : "F", id : 13 }
            , { letter : "O", id : 14 }
            ]
          , [ { letter : "C", id : 15 }
            , { letter : "D", id : 16 }
            , { letter : "D", id : 17 }
            , { letter : "G", id : 18 }
            , { letter : "U", id : 19 }
            ]
          , [ { letter : "X", id : 20 }
            , { letter : "D", id : 21 }
            , { letter : "U", id : 22 }
            , { letter : "E", id : 23 }
            , { letter : "R", id : 24 }
            ]
          ]
          ,
        players: [{ name: "james", score: 10}, {name: "martin", score: 5}]
    }
};

const elmDiv = document.getElementById('elm-container');
const elmApp = Elm.embed(Elm.GameBoard, elmDiv, initialState);

/* we will do this via channels eventually*/
elmApp.ports.boardState.send(initialState.boardState);

/* this will send the letters back to the server via a channel */
elmApp.ports.submit.subscribe( function(letters) {
  let str = letters.reduce( function(acc, letter, index, letters) {
    return acc + letter.letter;
  }, "");
  console.log(str);
});
