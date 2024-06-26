extends SessionState

class_name EndState

const POLLING_TIME = 5

var title_scene_templ = preload("res://pages/title_screen/title_screen.tscn")

enum StateName {
	SETUP,
	POLLING,
	POLLED,
}

var _state_name: StateName = StateName.SETUP
var _new_state = null
var _next_poll = -1
var _locked = false

func _init(init_match_manager: MatchManager, new_state: Dictionary):
	super(init_match_manager)
	_new_state = new_state

func clear():
	pass

func update():
	var cur_time = Time.get_unix_time_from_system()
	match _state_name:
		StateName.SETUP:
			Global.last_session = Global.current_session
			Global.last_session.state = _new_state
			Global.current_session = null
			ui_manager.ChangeUI("RESULTS", {})
			ui_manager.main_menu.connect(_main_menu)
			_state_name = StateName.POLLING
		StateName.POLLING:
			if not _locked and cur_time >= _next_poll:
				_poll(
					Global.last_session.id,
					Global.user.token
				)

func _poll(session_id, player_token):
	_locked = true
	var url = ProjectSettings.get_setting("application/config/user_service_url")
	url = url + ("/match-histories/%s/poll" % [session_id])
	
	var data_request = HTTPRequest.new()
	match_manager.add_child(data_request)
	data_request.request_completed.connect(_on_poll.bind(data_request))
	
	var err = data_request.request(
		url,
		[
			"Content-Type: application/json",
			"Authorization: Bearer %s" % [player_token],
		],
		HTTPClient.METHOD_GET
	)
	if err != OK:
		_prepare_next_poll()

func _on_poll(result, response_code, _headers, body, request_obj):
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		_prepare_next_poll()
		return
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	
	var rewards = RewardDto.new()
	rewards.add("experience", response["experience"])
	rewards.add("rating", response["rating"])
	
	ui_manager.current_ui.set_rewards(rewards)
	request_obj.queue_free()

func _prepare_next_poll():
	var cur_time = Time.get_unix_time_from_system()
	_next_poll = cur_time + POLLING_TIME
	_locked = false

func _main_menu():
	SceneManager.change_scene(SceneManager.SceneName.TITLE_SCREEN)
