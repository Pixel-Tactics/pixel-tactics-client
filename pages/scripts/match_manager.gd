extends Node

class_name MatchManager

@onready var match_api = $MatchAPI
@onready var map_manager = $Map
@onready var ui_manager = $UI

var current_state: SessionState = null
var match_data = Session.new()

func _ready():
	current_state = CredentialsState.new(self)

func _process(_delta):
	if current_state != null:
		current_state.update()

func change_match_state(new_state: SessionState):
	current_state.clear()
	current_state = new_state

func is_player_active():
	if match_data.state == null:
		return false
	if match_data.state.name == "PLAYER_1_TURN":
		return (match_data.player_index == 1)
	elif match_data.state.name == "PLAYER_2_TURN":
		return (match_data.player_index == 2)
	return false

func get_player_by_id(player_id: String):
	if match_data.player.id == player_id:
		return match_data.player
	elif match_data.opponent.id == player_id:
		return match_data.opponent
	return null

func get_opponent_by_id(player_id: String):
	if match_data.player.id == player_id:
		return match_data.opponent
	elif match_data.opponent.id == player_id:
		return match_data.player
	return null
