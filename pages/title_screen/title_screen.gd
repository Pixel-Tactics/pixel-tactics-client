extends Node

@onready var ui = $UI
@onready var invite_api = $InviteAPI

var is_requesting = false

func _ready():
	ui.invite_submit.connect(_send_invite_request)
	invite_api.invited.connect(_invite_received)
	invite_api.session_started.connect(_session_started)
	Global.update_user()

func _send_invite_request(user_id):
	invite_api.send_request("CREATE_SESSION", {
		"opponent_id": user_id,
	})

func _invite_received(player_id):
	ui.notify(str(player_id) + " INVITED")

func _session_started(session_id: String, opponent_id: String):
	Global.current_session = Session.new()
	Global.current_session.id = session_id
	Global.current_session.player = Player.new(Global.user.username, [], [])
	Global.current_session.opponent = Player.new(opponent_id, [], [])
	SceneManager.change_scene(SceneManager.SceneName.MATCH)
