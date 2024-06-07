extends Panel

class_name BattlePotraitBackground

const AVAILABLE = 0
const SELECTED = 1
const UNAVAILABLE = 2

func _ready():
	add_theme_stylebox_override("panel", get_theme_stylebox("panel").duplicate())

func change_state(new_state: int):
	if new_state == AVAILABLE:
		get_theme_stylebox("panel").bg_color = Color.GRAY
	elif new_state == SELECTED:
		get_theme_stylebox("panel").bg_color = Color.BEIGE
	else:
		get_theme_stylebox("panel").bg_color = Color.TRANSPARENT
