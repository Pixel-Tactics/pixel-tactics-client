extends Control

signal hero_action_start_request
signal end_turn
signal forfeit

var potrait_templ = preload("res://ui/match/battle_potrait/battle_potrait.tscn")

@onready var state_label = $State
@onready var forfeit_button = $ActionButtons/Forfeit
@onready var action_buttons = $ActionButtons
@onready var player_label = $PlayerData/Label
@onready var player_potrait_list = $PlayerData/PotraitList
@onready var opponent_label = $OpponentData/Label
@onready var opponent_potrait_list = $OpponentData/PotraitList
@onready var end_turn_button = $ActionButtons/EndTurn
@onready var timer = $Timer

var player_potrait_track = {}
var opponent_potrait_track = {}

var is_player: bool = false
var deadline: float = -1
var player_name: String = ""
var opponent_name: String = ""
var player_hero: Array[BaseHero] = []
var opponent_hero: Array[BaseHero] = []

func init(player: Player, opponent: Player, init_is_player: bool, init_deadline: float):
	is_player = init_is_player
	deadline = init_deadline
	player_name = player.id
	player_hero = player.hero_list
	opponent_name = opponent.id
	opponent_hero = opponent.hero_list

func _ready():
	if player_name == "":
		return
	
	end_turn_button.pressed.connect(_on_end_turn.bind())
	timer.end_time = deadline
	player_label.text = player_name
	forfeit_button.connect("pressed", _on_forfeit.bind())
	for hero in player_hero:
		var hero_potrait = potrait_templ.instantiate()
		hero_potrait.init(hero)
		hero_potrait.change_state(BattlePotraitBackground.UNAVAILABLE)
		hero_potrait.connect("pressed", _on_hero_select.bind())
		player_potrait_list.add_child(hero_potrait)
		player_potrait_track[hero.hero_name] = hero_potrait
	opponent_label.text = opponent_name
	for hero in opponent_hero:
		var opponent_potrait = potrait_templ.instantiate()
		opponent_potrait.init(hero)
		opponent_potrait.change_state(BattlePotraitBackground.UNAVAILABLE)
		opponent_potrait_list.add_child(opponent_potrait)
		opponent_potrait_track[hero.hero_name] = opponent_potrait
	_update_turn()

func change_turn(new_is_player: bool, new_deadline: float):
	is_player = new_is_player
	deadline = new_deadline
	_update_turn()

func _update_turn():
	if is_player:
		state_label.text = "Player's Turn"
		action_buttons.visible = true
		for potrait in player_potrait_track.values():
			potrait.change_state(BattlePotraitBackground.AVAILABLE)
	else:
		state_label.text = "Opponent's Turn"
		action_buttons.visible = false
		for potrait in player_potrait_track.values():
			potrait.change_state(BattlePotraitBackground.UNAVAILABLE)
	timer.end_time = deadline

func reset_hero_action(hero: BaseHero):
	if player_potrait_track.has(hero.hero_name):
		var hero_potrait = player_potrait_track[hero.hero_name]
		hero_potrait.change_state(BattlePotraitBackground.AVAILABLE)

func start_hero_action(hero: BaseHero):
	if player_potrait_track.has(hero.hero_name):
		var hero_potrait = player_potrait_track[hero.hero_name]
		hero_potrait.change_state(BattlePotraitBackground.SELECTED)

func end_hero_action(hero: BaseHero):
	if player_potrait_track.has(hero.hero_name):
		var hero_potrait = player_potrait_track[hero.hero_name]
		hero_potrait.change_state(BattlePotraitBackground.UNAVAILABLE)

func _on_hero_select(hero: BaseHero):
	emit_signal("hero_action_start_request", hero)
	
func _on_end_turn():
	emit_signal("end_turn")

func _on_forfeit():
	emit_signal("forfeit")
