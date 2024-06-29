extends Node

@onready var ui = $UI

var is_requesting = false
var player_token = ""

func _ready():
	ui.login_submit.connect(_send_login_request)
	ui.register_submit.connect(_send_register_request)

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
		int(response.curExperience),
		int(response.maxExperience),
		int(response.rating),
		player_token,
	)
	Global.user = user
	request_obj.queue_free()
	_go_to_menu()
	is_requesting = false

func _go_to_menu():
	SceneManager.change_scene(SceneManager.SceneName.TITLE_SCREEN)
