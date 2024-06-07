extends Node

signal error_received

func handle_error(_message: Dictionary):
	emit_signal("error_received")

func send(message: Dictionary, identifier: String, socket: WebSocketPeer):
	var msg = JSON.stringify({
		"action": "EXECUTE_ACTION",
		"identifier": identifier,
		"body": {
			"actionName": message.action_name,
			"actionSpecific": message.action_specific,
		},
	}).to_utf8_buffer()
	socket.send(msg)
