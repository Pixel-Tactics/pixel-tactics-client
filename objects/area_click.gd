extends Area2D

signal pressed

func _input_event(viewport, event, shape_idx):
	if event.is_action_pressed("click"):
		emit_signal("pressed")
