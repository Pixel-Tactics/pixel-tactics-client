extends Node2D

class_name BaseHero

signal status_updated
signal move_completed

@export var hero_name: String = "Base"
@export var texture: Texture2D

@export var max_health: int
@export var health: int
@export var attack_range: int
@export var move_range: int
@export var basic_attack_path: String

# Movement
var _move_target_positions: Array[Vector2] = []
var _speed = 120

#var BasicAttack
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#BasicAttack = load(basic_attack_path)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
	
func _ready():
	#_move_target_positions = [Vector2(120,120), Vector2(50, 50)]
	pass
	
func _process(delta):
	_update_position(delta)
	pass

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

func damage_hero(diff: int):
	health = max(health - diff, 0)
	emit_signal("status_updated")
