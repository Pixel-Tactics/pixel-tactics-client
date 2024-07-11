extends Node2D

signal animation_ended

@onready var _animated_sprite = $AnimatedSprite2D
var _emitted = false

func _ready():
	_animated_sprite.animation_finished.connect(
		func():
			if _emitted:
				return
			_emitted = true
			animation_ended.emit()
	)

func play():
	_animated_sprite.play("default")
