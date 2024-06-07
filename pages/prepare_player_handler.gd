extends Node

signal success_received
signal error_received

var progress_id = ""

func handle_incoming(message: Dictionary):
	var cur_id = message.identifier
	if progress_id != cur_id:
		return
	emit_signal("success_received")

func handle_error(_message: Dictionary):
	emit_signal("error_received")

func send(message: Dictionary, identifier: String, socket: WebSocketPeer):
	progress_id = identifier
	var msg = JSON.stringify({
		"action": "PREPARE_PLAYER",
		"identifier": identifier,
		"body": {
			"chosenHeroList": message.chosen_hero_list,
		},
	}).to_utf8_buffer()
	socket.send(msg)
