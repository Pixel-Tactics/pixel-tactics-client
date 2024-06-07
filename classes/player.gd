extends Object

class_name Player

var id: String = ""
var hero_list: Array[BaseHero] = []
var raw_hero_list: Array = []

func _init(init_id: String, init_hero_list: Array[BaseHero], init_raw_hero_list: Array[Dictionary]):
	id = init_id
	hero_list = init_hero_list
	raw_hero_list = init_raw_hero_list

func get_hero_from_name(hero_name: String):
	for hero in hero_list:
		if hero.hero_name.to_lower() == hero_name:
			return hero
	return null

func find_hero_on_pos(pos: Vector2):
	for hero in hero_list:
		if hero.position == pos:
			return hero
	return null
