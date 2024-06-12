extends Node

signal success_received
signal error_received

var progress_id = ""

func handle_incoming(message: Dictionary):
	var cur_id = message.identifier
	if progress_id != cur_id:
		return
	
	if message.action == "FEEDBACK":
		emit_signal("success_received")
	elif message.action == "ERROR":
		emit_signal("error_received")

func send(message: Dictionary, identifier: String, socket: WebSocketPeer):
	progress_id = identifier
	var msg = JSON.stringify({
		"action": "AUTH",
		"identifier": identifier,
		"body": {
			"playerToken": message.player_token,
		},
	}).to_utf8_buffer()
	socket.send(msg)
