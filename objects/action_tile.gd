extends Node2D

class_name ActionTile

signal pressed

const ATTACK = preload("res://assets/attack-tile.png")
const MOVE = preload("res://assets/move-tile.png")

var action_type

@onready var sprite = $Sprite
@onready var area = $Area2D

func init(init_action_type):
	action_type = init_action_type

func _ready():
	if action_type != null:
		sprite.texture = action_type
	area.pressed.connect(_on_pressed.bind())

func _on_pressed():
	print("PRESSED")
	emit_signal("pressed", position)
