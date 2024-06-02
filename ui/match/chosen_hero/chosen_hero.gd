extends NinePatchRect

class_name ChosenHeroUI

signal hero_removed

@export var hero: BaseHero = null
@export var index: int = 0

@onready var potrait = $Potrait
@onready var button = $Button

func init(new_index: int):
	name = "ChosenHero" + str(new_index)
	index = new_index
	hero = null
	
func set_hero(new_hero: BaseHero):
	hero = new_hero
	_update_ui()

func _ready():
	_update_ui()
	button.connect("pressed", _on_pressed.bind())

func _update_ui():
	if hero != null:
		potrait.texture = hero.texture
	else:
		potrait.texture = null

func _on_pressed():
	emit_signal("hero_removed", hero)
