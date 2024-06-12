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
		ui_manager.ChangeUI("LOADING")
		match_api.send_request("GET_SESSION", {
			"session_id": Global.current_session.id,
		})
		match_api.send_request("SERVER_TIME")
		request_sent = true
	elif ui_prepared:
		match_manager.change_match_state(PreparationState.new(match_manager))
	elif time_synced and session_loaded:
		load_match()
		ui_prepared = true

func load_match():
	match_manager.map_manager.generate_map(Global.current_session.map)
	var hero_instances = []
	for hero_name in Global.current_session.heroes_template.keys():
		var hero_instance: BaseHero = Global.current_session.heroes_template[hero_name].instantiate()
		hero_instance.visible = false
		hero_instances.append(hero_instance)
	Global.current_session.heroes_ui_instance = hero_instances

func _on_session_get(session_data: Dictionary):
	print("SESSION GET")
	if Global.current_session.player.id == session_data["player1"]["id"]:
		Global.current_session.player_index = 1
	else:
		Global.current_session.player_index = 2
	Global.current_session.state = session_data["state"]
	Global.current_session.map = session_data["matchMap"]["structure"]
	
	var heroes_name: Array = session_data["availableHeroList"]
	for hero_name in heroes_name:
		Global.current_session.heroes_template[hero_name] = load("res://heroes/" + hero_name + ".tscn")
	session_loaded = true

func _on_time_synced():
	time_synced = true
