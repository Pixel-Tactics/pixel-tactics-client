extends SessionState

class_name BattleState

enum UpdateType {
	STATE_CHANGE,
	ACTION,
}

var ui_changed = false
var request_sent = false
var started = false

var selected_hero: BaseHero = null
var update_list = []
var update_type_count = {}
var applied_update_idx = -1
var in_animation = false

func _init(init_match_manager: MatchManager):
	super(init_match_manager)
	
	for val in UpdateType.values():
		update_type_count[val] = 0
	
	ui_manager.hero_start_request.connect(_on_hero_select.bind())
	ui_manager.end_turn.connect(_on_end_turn.bind())
	map_manager.move_tile_selected.connect(_on_hero_move.bind())
	map_manager.attack_tile_selected.connect(_on_hero_attack.bind())
	match_api.action_accepted.connect(_on_action_accepted.bind())
	match_api.session_get.connect(_on_session_get.bind())
	match_api.state_changed.connect(_on_state_changed.bind())

func update():
	if not ui_changed:
		var is_player = match_manager.is_player_active()
		ui_manager.ChangeUI("BATTLE", {
			"player": Global.current_session.player,
			"opponent": Global.current_session.opponent,
			"init_is_player": is_player,
			"init_deadline": Global.current_session.state.deadline,
		})
		ui_changed = true
		return
	
	if applied_update_idx < len(update_list) - 1 and not in_animation:
		applied_update_idx += 1
		var cur_update = update_list[applied_update_idx]
		match cur_update[0]:
			UpdateType.ACTION:
				match cur_update[1]["name"]:
					"move":
						_anim_hero_move(cur_update[1])
					"attack":
						_anim_hero_attack(cur_update[1])
						
			UpdateType.STATE_CHANGE:
				_state_change(cur_update[1])

func _anim_hero_move(action: Dictionary):
	if Global.current_session == null:
		return
	var player = match_manager.get_player_by_id(action["playerId"])
	if not player:
		return
	var hero = player.get_hero_from_name(action["hero"])
	if not hero:
		return
	
	var hero_pos = map_manager.world_to_map(hero.position)
	var target_poses = map_manager.vector_plus_directions_progress(
		hero_pos,
		action["directionList"]
	)
	var target_wld_poses: Array[Vector2] = []
	for cur_pos in target_poses:
		var cur_wld_pos = map_manager.map_to_world(cur_pos)
		target_wld_poses.push_back(cur_wld_pos)
	if len(target_wld_poses) > 0:
		in_animation = true
		hero.move_completed.connect(_anim_hero_move_ended)
		hero.move_multiple(target_wld_poses)
	else:
		_anim_hero_move_ended(hero, true)

func _anim_hero_move_ended(hero, direct = false):
	if not direct:
		hero.move_completed.disconnect(_anim_hero_move_ended)
	if selected_hero == hero and applied_update_idx == len(update_list) - 1:
		var map = Global.current_session.map
		var hero_pos = map_manager.world_to_map(hero.position)
		map_manager.make_attack_tiles(map, hero_pos, hero.attack_range)
	in_animation = false

func _anim_hero_attack(action: Dictionary):
	if Global.current_session == null:
		return
	
	var player = match_manager.get_player_by_id(action["playerId"])
	if not player:
		return	
	var opponent = match_manager.get_opponent_by_id(action["playerId"])
	if not opponent:
		return
		
	var hero = player.get_hero_from_name(action["hero"])
	if not hero:
		return
	var target = opponent.get_hero_from_name(action["target"])
	if not target:
		return
	
	in_animation = true
	hero.attack_animation.animation_ended.connect(
		_anim_hero_attack_ended.bind(hero, target, action["damage"])
	)
	hero.attack_animation.start_animation(
		Vector2.ZERO,
		[target] as Array[BaseHero],
		map_manager.projectiles
	)

func _anim_hero_attack_ended(hero, target, damage):
	hero.attack_animation.animation_ended.disconnect(
		_anim_hero_attack_ended
	)
	target.damage_hero(damage)
	in_animation = false

func _on_hero_select(hero: BaseHero):
	if selected_hero == null and match_manager.is_player_active():
		var map = Global.current_session.map
		var src = match_manager.map_manager.world_to_map(hero.position)
		var hero_list = []
		for cur in Global.current_session.player.hero_list:
			hero_list.append(match_manager.map_manager.world_to_map(cur.position))
		for cur in Global.current_session.opponent.hero_list:
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
		var target_hero = Global.current_session.opponent.find_hero_on_pos(target_pos)
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

func _on_action_accepted(action_data: Dictionary):
	var order = action_data["order"]
	if update_type_count[UpdateType.ACTION] != order:
		push_warning("order not matching, getting session..")
		_get_session()
		return
	update_type_count[UpdateType.ACTION] += 1
	update_list.push_back([UpdateType.ACTION, action_data])

func _on_state_changed(session_data: Dictionary):
	var order = len(session_data["actionLog"])
	if update_type_count[UpdateType.ACTION] != order:
		push_warning("order not matching, getting session..")
		_get_session()
		return
	update_type_count[UpdateType.STATE_CHANGE] += 1
	update_list.push_back([UpdateType.STATE_CHANGE, session_data])

func _on_end_turn():
	match_manager.match_api.send_request("END_TURN")

func _state_change(session_data: Dictionary):
	# TODO: put action UI to stop if player in_animation
	var new_state = session_data.state
	if new_state.name == "PLAYER_1_TURN" or new_state.name == "PLAYER_2_TURN":
		Global.current_session.state = new_state
		selected_hero = null
		map_manager.remove_tiles()
		ui_manager.current_ui.change_turn(match_manager.is_player_active(), new_state.deadline)
	elif new_state.name == "END":
		match_manager.change_match_state(EndState.new(match_manager, new_state))

func _get_session():
	match_manager.match_api.send_request("GET_SESSION", {})

func _on_session_get(session_data: Dictionary):
	push_warning(session_data)
	session_data["actionLog"]
	
