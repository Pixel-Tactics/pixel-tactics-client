extends Panel

class_name ToastBox

const ERROR = preload("res://assets/ui/icons/Exclamation-Mark.png")
const LOADING = preload("res://assets/ui/icons/Clock.png")
const INFO = preload("res://assets/ui/icons/Mail.png")

@export var content_text: String = "Lorem Ipsum"
@export var type: Resource = ERROR
@export var color: Color = Color.INDIAN_RED

@onready var contents = $Contents
@onready var icon = $Icon

func init(init_type: Resource, init_content_text: String, init_color: Color = Color.INDIAN_RED):
	content_text = init_content_text
	type = init_type
	if init_type == ERROR:
		color = Color(255.0/255.0, 119.0/255.0, 107.0/255.0)
	elif init_type == LOADING:
		color = Color.DIM_GRAY
	elif init_type == INFO:
		color = Color(223.0/255.0, 173.0/255.0, 99.0/255.0)
	else:
		color = init_color

func _ready():
	add_theme_stylebox_override("panel", get_theme_stylebox("panel").duplicate())
	_update_ui()

func _update_ui():
	contents.text = content_text
	icon.texture = type
	get_theme_stylebox("panel").bg_color = color
