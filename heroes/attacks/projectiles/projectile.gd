extends Node2D

signal animation_ended

@onready var _animated_sprite = $AnimatedSprite2D
var _emitted = false

func _ready():
	_animated_sprite.animation_finished.connect(
		func():
			push_error("EMITTING PROJECTILE")
			if _emitted:
				return
			push_error(self)
			_emitted = true
			animation_ended.emit()
	)

func play():
	_animated_sprite.play("default")
