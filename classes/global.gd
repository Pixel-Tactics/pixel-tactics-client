extends Node

signal user_updated
signal user_update_error

var user: User = null
var last_session: Session = null
var current_session: Session = null

var _is_requesting = false
var _player_token = null

func set_player_token(pplayer_token):
	_player_token = pplayer_token

func update_user():
	if not _is_requesting:
		_is_requesting = true
		var url = ProjectSettings.get_setting("application/config/user_service_url")
		url = url + "/auth/current"
		
		var request = HTTPRequest.new()
		add_child(request)
		request.request_completed.connect(_update_user_completed.bind(request))
		
		var err = request.request(
			url,
			[
				"Content-Type: application/json",
				"Authorization: Bearer %s" % [_player_token],
			],
			HTTPClient.METHOD_GET
		)
		if err != OK:
			user_update_error.emit("CONNECTION ERROR")
			_is_requesting = false

func _update_user_completed(result, response_code, _headers, body, request_obj):
	if result != HTTPRequest.RESULT_SUCCESS:
		user_update_error.emit("CONNECTION ERROR")
		_is_requesting = false
		return
	if response_code != 200:
		user_update_error.emit("INVALID INPUT")
		_is_requesting = false
		return
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	var new_user = User.new(
		response.username,
		int(response.level),
		int(response.experience),
		int(response.curExperience),
		int(response.maxExperience),
		int(response.rating),
		_player_token,
	)
	user = new_user
	request_obj.queue_free()
	_is_requesting = false
	user_updated.emit()
