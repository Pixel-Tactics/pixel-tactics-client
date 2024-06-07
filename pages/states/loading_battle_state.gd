extends SessionState

class_name LoadingBattleState

var hero_prepared = false

func _init(init_match_manager: MatchManager):
	super(init_match_manager)

func clear():
	pass

func update():
	if not hero_prepared:
		ui_manager.ChangeUI("LOADING")
		_load_hero()
	else:
		match_manager.change_match_state(BattleState.new(match_manager))

func _load_player_hero(player: Player):
	var hero_list: Array[BaseHero] = []
	for raw_hero in player.raw_hero_list:
		var hero_template = match_manager.match_data.heroes_template[raw_hero.template.name]
		var hero: BaseHero = hero_template.instantiate()
		var map_pos = Vector2(raw_hero.pos.x, raw_hero.pos.y)
		hero.position = match_manager.map_manager.map_to_world(map_pos)
		match_manager.map_manager.heroes.add_child(hero)
		hero_list.append(hero)
	player.hero_list = hero_list

func _load_hero():
	var player = match_manager.match_data.player
	var opponent = match_manager.match_data.opponent
	_load_player_hero(player)
	_load_player_hero(opponent)
	hero_prepared = true
