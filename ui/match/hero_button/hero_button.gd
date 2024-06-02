extends NinePatchRect

class_name HeroButtonUI

signal hero_choosed

@export var hero: BaseHero = null

@onready var potrait = $Potrait
@onready var hero_name = $HeroName
@onready var button = $Button

func init(new_hero: BaseHero):
	hero = new_hero
	name = new_hero.hero_name

func _ready():
	_update_ui()
	button.connect("pressed", _on_pressed.bind())

func _update_ui():
	if hero != null:
		potrait.texture = hero.texture
		hero_name.text = hero.hero_name
	else:
		potrait.texture = null
		hero_name.text = "Null"

func _on_pressed():
	emit_signal("hero_choosed", hero)
