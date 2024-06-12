extends Node

signal success_received
signal error_received

var progress_id = ""

func handle_incoming(message: Dictionary):
	var cur_id = message.identifier
	if progress_id != cur_id:
		return
	
	var local_end = Time.get_unix_time_from_system()
	
	var local_start = float(message.body["localTime"])
	var server_time = float(message.body["serverTime"])
	
	var trip_time = (local_end - local_start) / 2
	var cur_time = server_time + trip_time
	TimeManager.set_time(cur_time, local_end)
	emit_signal("success_received")

func handle_error(_message: Dictionary):
	emit_signal("error_received")

func send(_message: Dictionary, identifier: String, socket: WebSocketPeer):
	progress_id = identifier
	var msg = JSON.stringify({
		"action": "SERVER_TIME",
		"identifier": identifier,
		"body": {
			"localTime": Time.get_unix_time_from_system(),
		},
	}).to_utf8_buffer()
	socket.send(msg)
