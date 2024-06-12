extends Node

signal error_received

func handle_error(_message: Dictionary):
	emit_signal("error_received")

func send(_message: Dictionary, identifier: String, socket: WebSocketPeer):
	var msg = JSON.stringify({
		"action": "END_TURN",
		"identifier": identifier,
		"body": {},
	}).to_utf8_buffer()
	socket.send(msg)
