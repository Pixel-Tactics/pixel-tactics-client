extends SessionState

class_name InvitingState

var opponent_invited = false
var session_started = false

func _init(init_match_manager: MatchManager):
	super(init_match_manager)
	match_api.session_started.connect(_on_session_started.bind())

func clear():
	match_api.session_started.disconnect(_on_session_started.bind())

func update():
	if not opponent_invited:
		ui_manager.ChangeUI("LOADING")
		match_api.send_request("CREATE_SESSION", {
			"opponent_id": match_manager.match_data.opponent.id,
		})
		opponent_invited = true
	elif session_started:
		match_manager.change_match_state(LoadingPreparationState.new(match_manager))

func _on_session_started(session_id: String):
	print("STARTING " + session_id)
	match_manager.match_data.id = session_id
	session_started = true
