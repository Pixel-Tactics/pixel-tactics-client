extends Node

var match_scene = preload("res://pages/match/match.tscn").instantiate()

@onready var ui = $UI
@onready var invite_api = $InviteAPI

var is_requesting = false
var player_token = ""

func _ready():
	ui.login_submit.connect(_send_login_request)
	ui.register_submit.connect(_send_register_request)
	ui.invite_submit.connect(_send_invite_request)
	invite_api.invited.connect(_invite_received)
	invite_api.session_started.connect(_session_started)

func _send_login_request(username, password):
	if not is_requesting:
		is_requesting = true
		var url = ProjectSettings.get_setting("application/config/user_service_url")
		url = url + "/auth/login"
		var body = JSON.stringify({"username": username, "password": password})
		
		var log_request = HTTPRequest.new()
		add_child(log_request)
		log_request.request_completed.connect(_login_request_completed.bind(log_request))
		
		var err = log_request.request(
			url,
			["Content-Type: application/json"],
			HTTPClient.METHOD_POST,
			body
		)
		if err != OK:
			ui.form_error("CONNECTION ERROR")
			is_requesting = false

func _send_register_request(username, password):
	if not is_requesting:
		is_requesting = true
		var url = ProjectSettings.get_setting("application/config/user_service_url")
		url = url + "/auth/register"
		var body = JSON.stringify({"username": username, "password": password})
		
		var reg_request = HTTPRequest.new()
		add_child(reg_request)
		reg_request.request_completed.connect(_register_request_completed.bind(reg_request))
		
		var err = reg_request.request(
			url,
			["Content-Type: application/json"],
			HTTPClient.METHOD_POST,
			body
		)
		if err != OK:
			ui.form_error("CONNECTION ERROR")
			is_requesting = false

func _send_data_request(pplayer_token):
	if not is_requesting:
		is_requesting = true
		var url = ProjectSettings.get_setting("application/config/user_service_url")
		url = url + "/auth/current"
		
		var data_request = HTTPRequest.new()
		add_child(data_request)
		data_request.request_completed.connect(_data_request_completed.bind(data_request))
		
		var err = data_request.request(
			url,
			[
				"Content-Type: application/json",
				"Authorization: Bearer %s" % [pplayer_token],
			],
			HTTPClient.METHOD_GET
		)
		if err != OK:
			ui.form_error("CONNECTION ERROR")
			is_requesting = false

func _send_invite_request(user_id):
	invite_api.send_request("CREATE_SESSION", {
		"opponent_id": user_id,
	})

func _login_request_completed(result, response_code, _headers, body, request_obj):
	if result != HTTPRequest.RESULT_SUCCESS:
		ui.form_error("CONNECTION ERROR")
		is_requesting = false
		return
	if response_code != 200:
		ui.form_error("INVALID CREDENTIALS")
		is_requesting = false
		return
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	player_token = response.token
	request_obj.queue_free()
	is_requesting = false
	_send_data_request(player_token)

func _register_request_completed(result, response_code, _headers, body, request_obj):
	if result != HTTPRequest.RESULT_SUCCESS:
		ui.form_error("CONNECTION ERROR")
		is_requesting = false
		return
	if response_code != 200:
		ui.form_error("INVALID INPUT")
		is_requesting = false
		return
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	player_token = response.token
	request_obj.queue_free()
	is_requesting = false
	_send_data_request(player_token)

func _data_request_completed(result, response_code, _headers, body, request_obj):
	if result != HTTPRequest.RESULT_SUCCESS:
		ui.form_error("CONNECTION ERROR")
		is_requesting = false
		return
	if response_code != 200:
		ui.form_error("BAD REQUEST")
		is_requesting = false
		return
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	var user = User.new(
		response.username,
		int(response.level),
		int(response.experience),
		int(response.rating),
		player_token,
	)
	Global.user = user
	request_obj.queue_free()
	ui.go_to_menu()
	is_requesting = false

func _invite_received(player_id):
	ui.notify(str(player_id) + " INVITED")

func _session_started(session_id: String, opponent_id: String):
	Global.current_session = Session.new()
	Global.current_session.id = session_id
	Global.current_session.player = Player.new(Global.user.username, [], [])
	Global.current_session.opponent = Player.new(opponent_id, [], [])
	get_tree().root.add_child(match_scene)
	queue_free()
