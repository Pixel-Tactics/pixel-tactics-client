extends VBoxContainer

var toast_box_template = preload("res://ui/general/toast/toast_box.tscn")
var toast_list: Array[Dictionary] = []

const DURATION = 5

func _process(_delta):
	var front_toast = front()
	var cur_time = Time.get_unix_time_from_system()
	if front_toast != null and cur_time > front_toast.expired_at:
		pop()

func front():
	if len(toast_list) > 0:
		return toast_list[0]
	return null

func pop():
	var toast = front()
	toast_list.pop_front()
	toast.toast_box.queue_free()

func push(message: String):
	var toast_box = toast_box_template.instantiate()
	toast_box.init(message)
	var cur_time = Time.get_unix_time_from_system()
	toast_list.push_back({
		"message": message,
		"expired_at": cur_time + DURATION,
		"toast_box": toast_box,
	})
	add_child(toast_box)
