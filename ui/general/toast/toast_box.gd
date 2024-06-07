extends Panel

@export var content_text: String = ""

@onready var contents = $Contents

func init(init_content_text: String):
	content_text = init_content_text

func _ready():
	_update_ui()

func _update_ui():
	contents.text = content_text
