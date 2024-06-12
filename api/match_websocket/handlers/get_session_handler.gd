extends Node

signal success_received
signal error_received

var progress_id = ""

func handle_incoming(message: Dictionary):
	print("INCOMING")
	var cur_id = message.identifier
	if cur_id != progress_id:
		return
	print("EMITTING")
	emit_signal("success_received", message.body)
		
func handle_error(_message: Dictionary):
	print("ERRORING")
	emit_signal("error_received")

func send(message: Dictionary, identifier: String, socket: WebSocketPeer):
	progress_id = identifier
	var msg = JSON.stringify({
		"action": "GET_SESSION",
		"identifier": identifier,
		"body": {
			"sessionId": message.session_id,
		},
	}).to_utf8_buffer()
	print("SENDOS GET SESSION")
	socket.send(msg)
