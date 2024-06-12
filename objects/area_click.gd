extends Area2D

signal pressed

func _input_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("click"):
		emit_signal("pressed")
