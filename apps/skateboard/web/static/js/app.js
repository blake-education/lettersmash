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

import socket from "./socket"

const elmDiv = document.getElementById('elm-container');
const elmApp = Elm.GameBoard.embed(elmDiv);

/* we will do this via channels eventually*/
//elmApp.ports.boardState.send(initialState.boardState);

// CHANNELS
let channel = socket.channel("game:game1", {})
channel.join()
  .receive("ok", resp => {
    console.log("Joined successfully", resp);
    channel.push("board_state")
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

channel.on("board_state", board_state => {
  console.log("board state: ", board_state);
  elmApp.ports.boardState.send(board_state);
})

channel.on("game_over", data => {
  console.log("game_over: ", data);
  elmApp.ports.gameOver.send(data.message);
})

channel.on("submission_successful", data => {
  console.log("submission_successful: ", data);
  elmApp.ports.submitSuccess.send(data.message);
})

channel.on("submission_failed", data => {
  console.log("submission_failed: ", data);
  elmApp.ports.submitFailed.send(data.message);
})

elmApp.ports.submit.subscribe( function(letters) {
  channel.push("submit_word", letters);
});

elmApp.ports.requestNewGame.subscribe( function(message) {
  channel.push("new_game", {message: message});
});

