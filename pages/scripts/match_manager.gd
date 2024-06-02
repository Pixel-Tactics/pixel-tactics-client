extends Node

enum MatchState {
	CREDENTIALS,
	INVITING,
	LOADING,
	PREPARATION,
	PLAYER_TURN,
	ENEMY_TURN,
	END
}

@onready var match_api = $MatchAPI
@onready var map_manager = $Map
@onready var ui_manager = $UI

var match_state = MatchState.CREDENTIALS
var state_data = _get_default_state(match_state)
var match_data = Session.new()

#var match_data = {
	#"id": "",
	#"player_index": 0, # 1 or 2
	#"player1": "",
	#"player2": "",
	#"map": [],
	#"heroes_template": {},
	#"heroes_ui_instance": [],
	#"player_heroes": [],
	#"enemy_heroes": [],
#}

func _ready():
	ui_manager.credentials_submitted.connect(_on_credentials_submit.bind())
	match_api.auth_received.connect(_on_credentials_loaded.bind())
	match_api.session_started.connect(_on_session_started.bind())
	match_api.session_get.connect(_on_session_get.bind())
	match_api.time_synced.connect(_on_time_synced.bind())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match match_state:
		MatchState.CREDENTIALS:
			if state_data.state_start:
				ui_manager.ChangeUI("CREDENTIALS")
				state_data.state_start = false
		MatchState.INVITING:
			if state_data.state_start:
				ui_manager.ChangeUI("LOADING")
				match_api.send_request("CREATE_SESSION", {
					"opponent_id": match_data.opponent.id,
				})
				state_data.state_start = false
			elif match_data.is_session_known():
				_change_match_state(MatchState.LOADING)
		MatchState.LOADING:
			if state_data.state_start:
				print("LOADING")
				ui_manager.ChangeUI("LOADING")
				match_api.send_request("GET_SESSION", {
					"session_id": match_data.id,
				})
				match_api.send_request("SERVER_TIME")
				state_data.state_start = false
			elif state_data.is_ui_prepared:
				_change_match_state(MatchState.PREPARATION)
			elif state_data.is_time_synced and state_data.is_session_data_loaded:
				load_match()
		MatchState.PREPARATION:
			if state_data.state_start:
				ui_manager.ChangeUI("PREPARATION", {
					"hero_list": match_data.heroes_ui_instance,
					"end_time": match_data.state.deadline,
				})
				state_data.state_start = false
		MatchState.PLAYER_TURN:
			pass
		MatchState.ENEMY_TURN:
			pass
		MatchState.END:
			pass

func _get_default_state(state: MatchState):
	match state:
		MatchState.CREDENTIALS:
			return {
				"state_start": true,
			}
		MatchState.INVITING:
			return {
				"state_start": true
			}
		MatchState.LOADING:
			return {
				"state_start": true,
				"is_time_synced": false,
				"is_session_data_loaded": false,
				"is_ui_prepared": false,
			}
		MatchState.PREPARATION:
			return {
				"state_start": true,
			}
		MatchState.PLAYER_TURN:
			return {}
		MatchState.ENEMY_TURN:
			return {}
		MatchState.END:
			return {}
	return {}
	
func load_match():
	map_manager.generate_map(match_data.map)
	var hero_instances = []
	for hero_name in match_data.heroes_template.keys():
		var hero_instance: BaseHero = match_data.heroes_template[hero_name].instantiate()
		hero_instance.visible = false
		hero_instances.append(hero_instance)
	match_data.heroes_ui_instance = hero_instances
	state_data.is_ui_prepared = true

func _change_match_state(new_state: MatchState):
	match_state = new_state
	state_data = _get_default_state(new_state)

# Event Handlers
func _on_credentials_submit(player_id: String, opponent_id: String):
	match_api.init(player_id, opponent_id)

func _on_credentials_loaded(player_id: String, opponent_id: String):
	if match_state == MatchState.CREDENTIALS:
		match_data.player = Player.new(player_id, [])
		match_data.opponent = Player.new(opponent_id, [])
		_change_match_state(MatchState.INVITING)

func _on_session_started(session_id: String):
	if match_state == MatchState.INVITING:
		print("SETTING " + session_id)
		match_data.id = session_id

func _on_session_get(session_data: Dictionary):
	if match_state == MatchState.LOADING:
		if match_data.player.id == session_data["player1"]["id"]:
			match_data.player_index = 1
		else:
			match_data.player_index = 2
		match_data.state = session_data["state"]
		match_data.map = session_data["matchMap"]["structure"]
		
		var heroes_name: Array = session_data["availableHeroList"]
		for hero_name in heroes_name:
			match_data.heroes_template[hero_name] = load("res://heroes/" + hero_name + ".tscn")
		state_data.is_session_data_loaded = true

func _on_time_synced():
	if match_state == MatchState.LOADING:
		state_data.is_time_synced = true
