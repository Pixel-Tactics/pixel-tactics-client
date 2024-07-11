extends Node2D

class_name BaseHero

signal status_updated
signal move_completed

signal animation_attack_started
signal animation_ended

@export var hero_name: String = "Base"
@export var texture: Texture2D

@export var max_health: int
var health: int
@export var attack_range: int
@export var move_range: int
@export var basic_attack_path: String

# Movement
var _move_target_positions: Array[Vector2] = []
var _speed = 120

# Attack
var attack_animation: BaseAttackAnimation = null
var _attack_start_frame = 0
var _attack_end_frame = 0

# Highlight
var _has_highlight: bool = false

# Animation
@onready var _animated_sprite = $AnimatedSprite2D

func _ready():
	health = max_health
	_animated_sprite.material = _animated_sprite.material.duplicate()
	set_highlight(_has_highlight)
	_animated_sprite.frame_changed.connect(
		func():
			if _animated_sprite.animation == "attack" \
					and _animated_sprite.frame == _attack_start_frame:
				animation_attack_started.emit()
	)
	_animated_sprite.animation_finished.connect(
		func():
			if _animated_sprite.animation != "default":
				animation_ended.emit(_animated_sprite.animation)
	)

func _process(delta):
	_update_position(delta)

func _update_position(delta):
	if len(_move_target_positions) == 0:
		return
	
	var cur_position = self.position
	var target_position = _move_target_positions[0]
	var diff_total = target_position - cur_position
	var diff = diff_total.normalized() * _speed * delta
	if diff.length() >= diff_total.length():
		diff = diff_total
	self.position += diff
	if self.position == target_position:
		_move_target_positions.pop_front()
		if len(_move_target_positions) == 0:
			self.move_completed.emit(self)

func move_multiple(target_positions: Array[Vector2]):
	if len(_move_target_positions) > 0:
		push_error("hero is moving")
		return
	_move_target_positions = target_positions

func move(target_position: Vector2):
	move_multiple([target_position])

func set_has_highlight(has_highlight: bool):
	_has_highlight = has_highlight

func set_highlight(is_active: bool):
	var new_value = 1 if is_active and _has_highlight else 0
	var shader_material = _animated_sprite.material as ShaderMaterial
	var last_value = shader_material.get_shader_parameter("line_thickness")
	if last_value != new_value:
		shader_material.set_shader_parameter("line_thickness", new_value)

func play_animation(animation_name):
	set_highlight(false)
	_animated_sprite.animation_finished.connect(
		func():
			if _animated_sprite.animation != "default":
				set_highlight(true)
				_animated_sprite.play("default")
	)
	_animated_sprite.play(animation_name)

func damage_hero(diff: int):
	health = max(health - diff, 0)
	emit_signal("status_updated")
