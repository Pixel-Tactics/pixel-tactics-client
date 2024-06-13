extends HBoxContainer

@onready var key_label = $Key
@onready var value_label = $Value

var key_text = ""
var value_text = ""

func _init(key, value):
	key_text = key
	value_text = value

func _ready():
	key_label.text = key_text
	value_label.text = value_text
