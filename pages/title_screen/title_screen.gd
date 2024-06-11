extends Node

@onready var login_request = $LoginRequest
@onready var register_request = $RegisterRequest
@onready var ui = $UI

var is_requesting = false
var player_token = ""

func _ready():
	ui.login_submit.connect(_send_login_request)
	ui.register_submit.connect(_send_register_request)
	login_request.request_completed.connect(_login_request_completed)
	register_request.request_completed.connect(_register_request_completed)

func _send_login_request(username, password):
	if not is_requesting:
		is_requesting = true
		var url = ProjectSettings.get_setting("application/config/user_service_url")
		url = url + "/auth/login"
		var body = JSON.new().stringify({"username": username, "password": password})
		var err = login_request.request(
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
		var body = JSON.new().stringify({"username": username, "password": password})
		var err = login_request.request(
			url,
			["Content-Type: application/json"],
			HTTPClient.METHOD_POST,
			body
		)
		if err != OK:
			ui.form_error("CONNECTION ERROR")
			is_requesting = false

func _login_request_completed(result, response_code, headers, body):
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
	ui.go_to_menu(player_token)
	is_requesting = false

func _register_request_completed(result, response_code, headers, body):
	print(body.get_string_from_utf8())
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
	ui.go_to_menu(player_token)
	is_requesting = false
