extends Object

class_name TimeManager

static var server_time: float = -1.0
static var last_cur_time: float = -1.0

static func set_time(new_server_time: float, new_cur_time: float):
	server_time = new_server_time
	last_cur_time = new_cur_time

static func get_time():
	if last_cur_time < 0:
		return null
	else:
		var cur_time = Time.get_unix_time_from_system()
		var diff = cur_time - last_cur_time
		return server_time + diff
