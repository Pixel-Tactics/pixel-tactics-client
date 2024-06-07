extends Control

signal submitted

var hero_list: Array = []
var chosen_list: Array = []

@export var hero_button_templ = preload("res://ui/match/hero_button/hero_button.tscn")
@export var chosen_button_templ = preload("res://ui/match/chosen_hero/chosen_hero.tscn")

@onready var timer = $Timer
@onready var hero_list_ui = $HeroList
@onready var chosen_list_ui = $ChosenList
@onready var submit_button = $Button

var chosen_button_list: Array[ChosenHeroUI] = []
var init_child_parameters = {}

func _ready():
	timer.end_time = init_child_parameters.end_time
	for hero in init_child_parameters.new_hero_list:
		var hero_button: HeroButtonUI = hero_button_templ.instantiate()
		hero_button.init(hero)
		hero_button.connect("hero_choosed", _on_hero_select.bind())
		hero_list_ui.add_child(hero_button)
	for i in range(2):
		var chosen_button = chosen_button_templ.instantiate()
		chosen_button.init(i)
		chosen_button.connect("hero_removed", _on_hero_remove.bind())
		chosen_list_ui.add_child(chosen_button)
		chosen_button_list.append(chosen_button)
	submit_button.connect("pressed", _on_submit.bind())

func init(new_hero_list: Array, end_time: int):
	hero_list = new_hero_list
	chosen_list = []
	init_child_parameters.new_hero_list = new_hero_list
	init_child_parameters.end_time = end_time

func _update_ui():
	for i in range(len(chosen_button_list)):
		if i > len(chosen_list) - 1:
			chosen_button_list[i].set_hero(null)
		else:
			chosen_button_list[i].set_hero(chosen_list[i])

func _on_hero_select(selected_hero: BaseHero):
	if chosen_list.find(selected_hero) < 0 and len(chosen_list) < 2:
		chosen_list.append(selected_hero)
		_update_ui()

func _on_hero_remove(selected_hero: BaseHero):
	var pos = chosen_list.find(selected_hero)
	if pos >= 0:
		chosen_list.remove_at(pos)
		_update_ui()

func _on_submit():
	emit_signal("submitted", chosen_list)
