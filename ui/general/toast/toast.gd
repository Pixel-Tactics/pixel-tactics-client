extends VBoxContainer

class_name Toast

var toast_box_template = preload("res://ui/general/toast/toast_box.tscn")
var toast_list: Array[Dictionary] = []

const DURATION = 5

func _ready():
	push(ToastBox.LOADING, "LOADING...")
	push(ToastBox.ERROR, "INVALID CREDENTIALS")
	push(ToastBox.ERROR, "INVALID USERNAME")

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
	var tween = get_tree().create_tween()
	tween.tween_property(toast.toast_box, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(toast.toast_box.queue_free)

func push(type: Resource, message: String):
	var toast_box = toast_box_template.instantiate()
	toast_box.init(type, message)
	toast_box.modulate.a = 0
	var cur_time = Time.get_unix_time_from_system()
	toast_list.push_back({
		"message": message,
		"expired_at": cur_time + DURATION,
		"toast_box": toast_box,
	})
	add_child(toast_box)
	
	var tween = get_tree().create_tween()
	tween.tween_property(toast_box, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_LINEAR)
