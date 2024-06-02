extends Node

signal success_received
signal error_received

var progress_id = ""

func handle_incoming(message: Dictionary):
	var cur_id = message.identifier
	if cur_id != progress_id:
		return
	emit_signal("success_received")
		
func handle_error(message: Dictionary):
	emit_signal("error_received")

func send(message: Dictionary, identifier: String, socket: WebSocketPeer):
	print("SENT INVITATION")
	progress_id = identifier
	var msg = JSON.stringify({
		"action": "CREATE_SESSION",
		"identifier": identifier,
		"body": {
			"opponentId": message.opponent_id,
		},
	}).to_utf8_buffer()
	socket.send(msg)
