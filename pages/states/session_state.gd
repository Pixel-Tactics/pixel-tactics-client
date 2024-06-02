extends Object

class_name SessionState

var match_manager: MatchManager = null
var match_api: MatchAPI = null
var ui_manager: MatchUIManager = null

func _init(init_match_manager: MatchManager):
	match_manager = init_match_manager
	ui_manager = match_manager.ui_manager
	match_api = match_manager.match_api

func clear():
	pass

func update():
	pass
