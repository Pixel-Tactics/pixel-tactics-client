extends NinePatchRect

signal pressed

@export var button_text = "Button"

@onready var button = $Button
@onready var button_name = $ButtonName

func _ready():
	button_name.text = button_text
	button.connect("pressed", _on_pressed.bind())
	
func _on_pressed():
	emit_signal("pressed")
