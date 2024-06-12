extends BaseWebSocketAPI

class_name InviteAPI

signal session_started
signal invited

@onready var start_session_handler = $StartSessionHandler
@onready var create_session_handler = $CreateSessionHandler
@onready var invite_session_handler = $InviteSessionHandler

func _ready():
	ready({
		"CREATE_SESSION": create_session_handler,
		"START_SESSION": start_session_handler,
		"INVITE_SESSION": invite_session_handler,
	})
	start_session_handler.success_received.connect(_on_session_start)
	invite_session_handler.success_received.connect(_on_invite)

func _on_session_start(session_id: String, opponent_id: String):
	emit_signal("session_started", session_id, opponent_id)

func _on_invite(player_id):
	emit_signal("invited", player_id)
