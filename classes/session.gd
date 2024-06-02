extends Object

class_name Session

var id: String = ""
var player_index: int = 0
var player: Player = null
var opponent: Player = null
var state: Dictionary = {}
var map: Array = []
var heroes_template: Dictionary = {}
var heroes_ui_instance: Array = []

func is_session_known():
	return id != ""
