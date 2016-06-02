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

// lobby channel
let channel = socket.channel("lobby", {})
channel.join()
  .receive("ok", resp => {
    console.log("Lobby joined successfully", resp);
    elmApp.ports.navigate.send("#/lobby");
    channel.push("game_list");
    elmApp.ports.newGame.subscribe( function(game_name) {
      console.log("New game " + game_name);
      channel.push("new_game");
    });
    elmApp.ports.joinGame.subscribe( function(game_name) {
      console.log("Joining game " + game_name);
      joinGame(game_name);
      channel.push("join_game", game_name);
      elmApp.ports.navigate.send("/#/game");
    });
    channel.on("games", games => {
      console.log("games: ", games);
      elmApp.ports.games.send(games.games);
    });
  })
  .receive("error", resp => { console.log("Unable to join", resp) })

function joinGame(name) {
  // Game channel
  let channel = socket.channel("game:" + name, {})
  channel.join()
    .receive("ok", resp => {
      console.log("Joined successfully", resp);
      elmApp.ports.navigate.send("#/game");
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

  elmApp.ports.newBoard.subscribe( function(message) {
    channel.push("new_board", {message: message});
  });
}
