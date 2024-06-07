extends Control

signal pressed

@export var hero: BaseHero = null

@onready var background = get_node("Background")
@onready var button = $Button
@onready var hero_ui = $Hero
@onready var potrait = $Hero/Potrait
@onready var health_bar = $Bar

var change_state_wait: int = -1

func init(init_hero: BaseHero):
	hero = init_hero

func _ready():
	if hero == null:
		return
	
	potrait.texture = hero.texture
	if change_state_wait < 0:
		background.change_state(BattlePotraitBackground.UNAVAILABLE)
	else:
		background.change_state(change_state_wait)
	button.connect("pressed", _on_pressed.bind())
	hero.connect("status_updated", _on_hero_update.bind())

func change_state(new_state: int):
	if background == null:
		change_state_wait = new_state
	else:
		background.change_state(new_state)

func _on_pressed():
	emit_signal("pressed", hero)

func _on_hero_update():
	print("DAMAGED UI")
	health_bar.update_health(hero.health, hero.max_health)
