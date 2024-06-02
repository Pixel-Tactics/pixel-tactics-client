extends SessionState

class_name PreparationState

var request_sent = false
var waiting_opponent = true

func _init(init_match_manager: MatchManager):
	super(init_match_manager)
	#match_api.session_get.connect(_on_session_get.bind())
	#match_api.time_synced.connect(_on_time_synced.bind())

func clear():
	#match_api.session_get.disconnect(_on_session_get.bind())
	#match_api.time_synced.disconnect(_on_time_synced.bind())
	pass

func update():
	if not request_sent:
		ui_manager.ChangeUI("PREPARATION", {
			"hero_list": match_manager.match_data.heroes_ui_instance,
			"end_time": match_manager.match_data.state.deadline,
		})
		request_sent = true
	
	#if not request_sent:
		#print("LOADING PREPARATION")
		#ui_manager.ChangeUI("LOADING")
		#match_api.send_request("GET_SESSION", {
			#"session_id": match_manager.match_data.id,
		#})
		#match_api.send_request("SERVER_TIME")
		#request_sent = true
	#elif ui_prepared:
		#match_manager._change_match_state(match_manager.MatchState.PREPARATION)
	#elif time_synced and session_loaded:
		#match_manager.load_match()
		#ui_prepared = true
	pass

func _on_session_get(session_data: Dictionary):
	#if match_manager.match_data.player.id == session_data["player1"]["id"]:
		#match_manager.match_data.player_index = 1
	#else:
		#match_manager.match_data.player_index = 2
	#match_manager.match_data.state = session_data["state"]
	#match_manager.match_data.map = session_data["matchMap"]["structure"]
	#
	#var heroes_name: Array = session_data["availableHeroList"]
	#for hero_name in heroes_name:
		#match_manager.match_data.heroes_template[hero_name] = load("res://heroes/" + hero_name + ".tscn")
	#session_loaded = true
	pass

func _on_time_synced():
	#time_synced = true
	pass
