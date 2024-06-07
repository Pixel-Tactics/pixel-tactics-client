extends SessionState

class_name BattleState

var ui_changed = false
var request_sent = false
var started = false

var selected_hero: BaseHero = null

func _init(init_match_manager: MatchManager):
	super(init_match_manager)
	ui_manager.hero_start_request.connect(_on_hero_select.bind())
	ui_manager.end_turn.connect(_on_end_turn.bind())
	map_manager.move_tile_selected.connect(_on_hero_move.bind())
	map_manager.attack_tile_selected.connect(_on_hero_attack.bind())
	match_api.move_accepted.connect(_on_move_accepted.bind())
	match_api.attack_accepted.connect(_on_attack_accepted.bind())
	match_api.state_changed.connect(_on_state_changed.bind())

func clear():
	pass

func update():
	if not ui_changed:
		var is_player = match_manager.is_player_active()
		ui_manager.ChangeUI("BATTLE", {
			"player": match_manager.match_data.player,
			"opponent": match_manager.match_data.opponent,
			"init_is_player": is_player,
			"init_deadline": match_manager.match_data.state.deadline,
		})
		ui_changed = true

func _on_hero_select(hero: BaseHero):
	if selected_hero == null and match_manager.is_player_active():
		var map = match_manager.match_data.map
		var src = match_manager.map_manager.world_to_map(hero.position)
		var hero_list = []
		for cur in match_manager.match_data.player.hero_list:
			hero_list.append(match_manager.map_manager.world_to_map(cur.position))
		for cur in match_manager.match_data.opponent.hero_list:
			hero_list.append(match_manager.map_manager.world_to_map(cur.position))
		
		match_manager.ui_manager.current_ui.start_hero_action(hero)
		match_manager.map_manager.make_move_tiles(map, src, hero.move_range, hero_list)
		selected_hero = hero

func _on_hero_move(dir_list: Array):
	if selected_hero != null and match_manager.is_player_active():
		match_manager.match_api.send_request("EXECUTE_ACTION", {
			"action_name": "move",
			"action_specific": {
				"heroName": selected_hero.hero_name.to_lower(),
				"directionList": dir_list,
			},
		})
		match_manager.map_manager.remove_tiles()
		
func _on_hero_attack(target_pos: Vector2i):
	if selected_hero != null and match_manager.is_player_active():
		var target_hero = match_manager.match_data.opponent.find_hero_on_pos(target_pos)
		if target_hero == null:
			return
		match_manager.match_api.send_request("EXECUTE_ACTION", {
			"action_name": "attack",
			"action_specific": {
				"heroName": selected_hero.hero_name.to_lower(),
				"targetName": target_hero.hero_name.to_lower(),
			},
		})
		match_manager.map_manager.remove_tiles()

func _on_move_accepted(action_specific: Dictionary):
	var player = match_manager.get_player_by_id(action_specific["playerId"])
	if not player:
		return
	var hero = player.get_hero_from_name(action_specific["hero"])
	if not hero:
		return
	var hero_pos = match_manager.map_manager.world_to_map(hero.position)
	var new_pos = match_manager.map_manager.vector_plus_directions(
		hero_pos,
		action_specific["directionList"]
	)
	var new_pos_world = match_manager.map_manager.map_to_world(new_pos)
	hero.position = new_pos_world
	if selected_hero == hero:
		var map = match_manager.match_data.map
		match_manager.map_manager.make_attack_tiles(map, new_pos, hero.attack_range)

func _on_attack_accepted(action_specific: Dictionary):
	var player = match_manager.get_opponent_by_id(action_specific["playerId"])
	if not player:
		return
	var target = player.get_hero_from_name(action_specific["target"])
	if not target:
		return
	target.damage_hero(action_specific["damage"])

func _on_end_turn():
	match_manager.match_api.send_request("END_TURN")

func _on_state_changed(session_data: Dictionary):
	var new_state = session_data.state
	if new_state.name == "PLAYER_1_TURN" or new_state.name == "PLAYER_2_TURN":
		match_manager.match_data.state = new_state
		selected_hero = null
		map_manager.remove_tiles()
		ui_manager.current_ui.change_turn(match_manager.is_player_active(), new_state.deadline)
