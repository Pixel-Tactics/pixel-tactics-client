extends Object

class_name Player

var id: String = ""
var hero_list: Array[BaseHero] = []

func _init(init_id: String, init_hero_list: Array[BaseHero]):
	id = init_id
	hero_list = init_hero_list
