extends Node2D

class_name BaseHero

signal status_updated

@export var hero_name: String = "Base"
@export var texture: Texture2D

@export var max_health: int
@export var health: int
@export var attack_range: int
@export var move_range: int
@export var basic_attack_path: String

#var BasicAttack
#
## Called when the node enters the scene tree for the first time.
#func _ready():
	#BasicAttack = load(basic_attack_path)
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func damage_hero(diff: int):
	health = max(health - diff, 0)
	emit_signal("status_updated")
