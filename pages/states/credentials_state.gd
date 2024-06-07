extends SessionState

class_name CredentialsState

var ui_changed = false

func _init(init_match_manager: MatchManager):
	super(init_match_manager)
	ui_manager.credentials_submitted.connect(_on_credentials_submit.bind())
	match_api.auth_received.connect(_on_credentials_loaded.bind())

func clear():
	ui_manager.credentials_submitted.disconnect(_on_credentials_submit.bind())
	match_api.auth_received.disconnect(_on_credentials_loaded.bind())

func update():
	if not ui_changed:
		match_manager.ui_manager.ChangeUI("CREDENTIALS")
		ui_changed = true

func _on_credentials_submit(player_id: String, opponent_id: String):
	match_api.init(player_id, opponent_id)

func _on_credentials_loaded(player_id: String, opponent_id: String):
	match_manager.match_data.player = Player.new(player_id, [], [])
	match_manager.match_data.opponent = Player.new(opponent_id, [], [])
	match_manager.change_match_state(InvitingState.new(match_manager))
