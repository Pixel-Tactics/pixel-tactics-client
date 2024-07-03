extends BaseWebSocketAPI

class_name MatchAPI

signal time_synced
signal session_get
signal player_prepared
signal state_changed
signal action_accepted

@onready var server_time_handler = $ServerTimeHandler
@onready var get_session_handler = $GetSessionHandler
@onready var prepare_player_handler = $PreparePlayerHandler
@onready var state_change_handler = $StateChangeHandler
@onready var execute_action_handler = $ExecuteActionHandler
@onready var apply_action_handler = $ApplyActionHandler
@onready var end_turn_handler = $EndTurnHandler

func _ready():
	ready({
		"SERVER_TIME": server_time_handler,
		"GET_SESSION": get_session_handler,
		"PREPARE_PLAYER": prepare_player_handler,
		"STATE_CHANGE": state_change_handler,
		"EXECUTE_ACTION": execute_action_handler,
		"APPLY_ACTION": apply_action_handler,
		"END_TURN": end_turn_handler,
	})
	server_time_handler.success_received.connect(_on_time_sync)
	get_session_handler.success_received.connect(_on_get_session)
	prepare_player_handler.success_received.connect(_on_player_prepared)
	state_change_handler.success_received.connect(_on_state_change)
	apply_action_handler.action_accepted.connect(_on_action_accept)

func _on_get_session(session_data: Dictionary):
	emit_signal("session_get", session_data)

func _on_time_sync():
	emit_signal("time_synced")

func _on_player_prepared():
	emit_signal("player_prepared")
	
func _on_state_change(session_data: Dictionary):
	emit_signal("state_changed", session_data)

func _on_action_accept(action_data: Dictionary):
	self.action_accepted.emit(action_data)
