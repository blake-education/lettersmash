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
            { letter : "M", id : 0, owner: 1 }
            , { letter : "U", id : 1, owner: 6 }
            , { letter : "S", id : 2, owner: 6 }
            , { letter : "Z", id : 3, owner: 5 }
            , { letter : "L", id : 4, owner: 1 }
            ]
          , [ { letter : "L", id : 5, owner: 1 }
            , { letter : "B", id : 6, owner: 1 }
            , { letter : "P", id : 7, owner: 1 }
            , { letter : "I", id : 8, owner: 5 }
            , { letter : "U", id : 9, owner: 5 }
            ]
          , [ { letter : "T", id : 10, owner: 1 }
            , { letter : "T", id : 11, owner: 1 }
            , { letter : "D", id : 12, owner: 4 }
            , { letter : "F", id : 13, owner: 4 }
            , { letter : "O", id : 14, owner: 0 }
            ]
          , [ { letter : "C", id : 15, owner: 0 }
            , { letter : "D", id : 16, owner: 2 }
            , { letter : "D", id : 17, owner: 2 }
            , { letter : "G", id : 18, owner: 4 }
            , { letter : "U", id : 19, owner: 2 }
            ]
          , [ { letter : "X", id : 20, owner: 3 }
            , { letter : "D", id : 21, owner: 3 }
            , { letter : "U", id : 22, owner: 3 }
            , { letter : "E", id : 23, owner: 2 }
            , { letter : "R", id : 24, owner: 2 }
            ]
          ]
          ,
        players: [{ name: "james", score: 10}, {name: "martin", score: 5}, {name: "emily", score: 25}, {name: "brian", score: 2}]
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
