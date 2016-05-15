import "phoenix_html"
import socket from "./socket"

const elmDiv = document.getElementById('elm-container');

if (elmDiv) {
  const elmApp = Elm.GameBoard.embed(elmDiv);

  // CHANNELS
  let channel = socket.channel("game:new", {})
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

}

// Lobby app
const elmDivLobby = document.getElementById('elm-lobby');
if (elmDivLobby) {
  const elmLobbyApp = Elm.GameLobby.embed(elmDivLobby);

  let channel = socket.channel("lobby", {})
  channel.join()
    .receive("ok", resp => {
      console.log("Joined successfully", resp);
    })
    .receive("error", resp => { console.log("Unable to join", resp) })

  channel.on("game_list", gameList => {
    console.log("gameList: ", gameList);
    elmLobbyApp.ports.gameList.send(gameList.games);
  })

  function createGame() {
    console.log("CreateGame!")
    channel.push("create_game")
  };

  const button = document.getElementById("create_game")
  button.onclick = createGame;
}
