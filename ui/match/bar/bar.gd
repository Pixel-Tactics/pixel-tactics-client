extends Control

@onready var frame = $Empty
@onready var full = $Empty/Full
@onready var label = $Label

func update_health(health: int, max_health: int):
	var scaling = float(health) / float(max_health)
	var total_length = float(frame.size.x)
	full.size.x = total_length * scaling
	label.text = "%d / %d" % [health, max_health]
