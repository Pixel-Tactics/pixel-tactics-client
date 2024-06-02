extends SessionState

class_name LoadingPreparationState

var request_sent = false
var time_synced = false
var session_loaded = false
var ui_prepared = false

func _init(init_match_manager: MatchManager):
	super(init_match_manager)
	match_api.session_get.connect(_on_session_get.bind())
	match_api.time_synced.connect(_on_time_synced.bind())

func clear():
	match_api.session_get.disconnect(_on_session_get.bind())
	match_api.time_synced.disconnect(_on_time_synced.bind())

func update():
	if not request_sent:
		print("LOADING PREPARATION")
		ui_manager.ChangeUI("LOADING")
		match_api.send_request("GET_SESSION", {
			"session_id": match_manager.match_data.id,
		})
		match_api.send_request("SERVER_TIME")
		request_sent = true
	elif ui_prepared:
		match_manager.change_match_state(PreparationState.new(match_manager))
	elif time_synced and session_loaded:
		load_match()
		ui_prepared = true

func load_match():
	match_manager.map_manager.generate_map(match_manager.match_data.map)
	var hero_instances = []
	for hero_name in match_manager.match_data.heroes_template.keys():
		var hero_instance: BaseHero = match_manager.match_data.heroes_template[hero_name].instantiate()
		hero_instance.visible = false
		hero_instances.append(hero_instance)
	match_manager.match_data.heroes_ui_instance = hero_instances

func _on_session_get(session_data: Dictionary):
	if match_manager.match_data.player.id == session_data["player1"]["id"]:
		match_manager.match_data.player_index = 1
	else:
		match_manager.match_data.player_index = 2
	match_manager.match_data.state = session_data["state"]
	match_manager.match_data.map = session_data["matchMap"]["structure"]
	
	var heroes_name: Array = session_data["availableHeroList"]
	for hero_name in heroes_name:
		match_manager.match_data.heroes_template[hero_name] = load("res://heroes/" + hero_name + ".tscn")
	session_loaded = true

func _on_time_synced():
	time_synced = true
