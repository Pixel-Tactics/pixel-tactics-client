extends Node

signal success_received

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
