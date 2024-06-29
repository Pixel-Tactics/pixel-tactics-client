extends Control

class_name BattlePotrait

signal pressed

@export var hero: BaseHero = null

@onready var button = $Button
@onready var potrait = $Margin/List/Hero/Potrait
@onready var health_bar = $Margin/List/Bar
@onready var arrow = $BattlePotrait/Arrow

const AVAILABLE = 0
const SELECTED = 1
const UNAVAILABLE = 2

var change_state_wait: int = -1

func init(init_hero: BaseHero):
	hero = init_hero

func _ready():
	if hero == null:
		return
	
	potrait.texture = hero.texture
	add_theme_stylebox_override("panel", get_theme_stylebox("panel").duplicate())
	if change_state_wait < 0:
		change_state(UNAVAILABLE)
	else:
		change_state(change_state_wait)
	button.connect("pressed", _on_pressed.bind())
	hero.connect("status_updated", _on_hero_update.bind())

func change_state(new_state: int):
	if arrow == null:
		change_state_wait = new_state
		return
	
	if new_state == AVAILABLE:
		arrow.visible = true
		get_theme_stylebox("panel").modulate_color = Color.WHITE
	elif new_state == SELECTED:
		arrow.visible = false
		get_theme_stylebox("panel").modulate_color = Color.BEIGE
	else:
		arrow.visible = false
		get_theme_stylebox("panel").modulate_color = Color.GRAY

func _on_pressed():
	emit_signal("pressed", hero)

func _on_hero_update():
	print("DAMAGED UI")
	health_bar.update_health(hero.health, hero.max_health)
