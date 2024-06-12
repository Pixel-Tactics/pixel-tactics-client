extends SessionState

class_name PreparationState

var ui_changed = false
var request_sent = false
var started = false

func _init(init_match_manager: MatchManager):
	super(init_match_manager)
	ui_manager.hero_submitted.connect(_on_hero_submit.bind())
	match_api.state_changed.connect(_on_state_changed.bind())

func clear():
	ui_manager.hero_submitted.disconnect(_on_hero_submit.bind())
	match_api.state_changed.disconnect(_on_state_changed.bind())

func update():
	if not ui_changed:
		ui_manager.ChangeUI("PREPARATION", {
			"hero_list": Global.current_session.heroes_ui_instance,
			"end_time": Global.current_session.state.deadline,
		})
		ui_changed = true
	elif started:
		match_manager.change_match_state(LoadingBattleState.new(match_manager))
	elif request_sent:
		pass


func _on_hero_submit(hero_list: Array):
	var hero_name_list = []
	for hero in hero_list:
		hero_name_list.append(hero.hero_name.to_lower())
	match_api.send_request("PREPARE_PLAYER", {
		"chosen_hero_list": hero_name_list,
	})
	request_sent = true

func _on_state_changed(session_data: Dictionary):
	var new_state = session_data.state
	if new_state.name == "PLAYER_1_TURN":
		var idx = Global.current_session.player_index
		var player_hero_list = session_data["player" + str(idx)]["heroList"]
		var opponent_hero_list = session_data["player" + str(idx % 2 + 1)]["heroList"]
		Global.current_session.player.raw_hero_list = player_hero_list
		Global.current_session.opponent.raw_hero_list = opponent_hero_list
		Global.current_session.state = new_state
		started = true
