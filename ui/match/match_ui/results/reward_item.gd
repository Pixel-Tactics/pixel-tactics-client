extends HBoxContainer

@onready var key_label = $Key
@onready var value_label = $Value

var key_text = ""
var value_text = ""

func init(key, value):
	key_text = key
	value_text = value

func _ready():
	key_label.text = str(key_text)
	if value_text >= 0:
		value_label.text = "+" + str(value_text)
	else:
		value_label.text = str(value_text)
