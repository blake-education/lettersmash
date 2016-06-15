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

import socket from "./socket"

const elmDiv = document.getElementById('elm-container');
const elmApp = Elm.GameBoard.embed(elmDiv);

/* we will do this via channels eventually*/

// CHANNELS
let channel = socket.channel("lobby", {})
channel.join()
  .receive("ok", resp => {
    console.log("Lobby joined successfully", resp);
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

