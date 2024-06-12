extends Node

class_name MatchManager

@onready var match_api = $MatchAPI
@onready var map_manager = $Map
@onready var ui_manager = $UI

var current_state: SessionState = null

func _ready():
	current_state = LoadingPreparationState.new(self)

func _process(_delta):
	if current_state != null:
		current_state.update()

func change_match_state(new_state: SessionState):
	current_state.clear()
	current_state = new_state

func is_player_active():
	if Global.current_session.state == null:
		return false
	if Global.current_session.state.name == "PLAYER_1_TURN":
		return (Global.current_session.player_index == 1)
	elif Global.current_session.state.name == "PLAYER_2_TURN":
		return (Global.current_session.player_index == 2)
	return false

func get_player_by_id(player_id: String):
	if Global.current_session.player.id == player_id:
		return Global.current_session.player
	elif Global.current_session.opponent.id == player_id:
		return Global.current_session.opponent
	return null

func get_opponent_by_id(player_id: String):
	if Global.current_session.player.id == player_id:
		return Global.current_session.opponent
	elif Global.current_session.opponent.id == player_id:
		return Global.current_session.player
	return null
