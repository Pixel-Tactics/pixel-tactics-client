extends Label

@export var end_time: int = -1

func _ready():
	_update_ui()

func _process(_delta):
	_update_ui()

func _update_ui():
	var cur_time = TimeManager.get_time()
	if cur_time != null and end_time != -1:
		cur_time = int(cur_time)
		var time_left = end_time - cur_time
		var minutes = time_left / 60
		var seconds = time_left % 60
		text = "%02d:%02d" % [minutes, seconds]
