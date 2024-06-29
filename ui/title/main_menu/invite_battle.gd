extends PanelContainer

signal invite_submitted
signal error_received

@onready var _search_field = $Container/Search/Username
@onready var _list = $Container/List/Container
@onready var _search_button = $Container/Search/Search
@onready var _refresh_button = $Container/Search/Refresh

var _invite_box_templ = preload("res://ui/title/main_menu/invite_box.tscn")
var _players_warning = preload("res://ui/title/main_menu/players_warning.tscn")

var _is_requesting = false
var _first_request = false
var _players = []

func _ready():
	_search_button.pressed.connect(_request_get_players)
	_refresh_button.pressed.connect(_request_get_players)

func _process(_delta):
	if not _first_request:
		_first_request = true
		_request_get_players()

func _update_players():
	var keyword = _get_keyword()
	var filtered_players = []
	for player in _players:
		if player == Global.user.username:
			continue
		if keyword == "" or player.to_lower().find(keyword.to_lower()) != -1:
			filtered_players.append(player)
	for child in _list.get_children():
		child.queue_free()
	if len(filtered_players) > 0:
		for player in filtered_players:
			var invite_box = _invite_box_templ.instantiate()
			invite_box.init(player)
			invite_box.invite_sent.connect(_invite_send)
			_list.add_child(invite_box)
	else:
		_list.add_child(_players_warning.instantiate())

func _get_keyword():
	return _search_field.text

func _invite_send(username):
	for child in _list.get_children():
		if child.username == username:
			child.disable()
		else:
			child.enable()
	invite_submitted.emit(username)

func _request_get_players():
	if not _is_requesting:
		_is_requesting = true
		var url = "http://" + ProjectSettings.get_setting("application/config/match_service_url")
		url = url + "/players"
		
		var request = HTTPRequest.new()
		add_child(request)
		request.request_completed.connect(_on_response_get_players.bind(request))
		
		var err = request.request(
			url,
			["Content-Type: application/json"],
			HTTPClient.METHOD_GET,
		)
		if err != OK:
			error_received.emit()
			_is_requesting = true

func _on_response_get_players(result, response_code, _headers, body, request_obj):
	if result != HTTPRequest.RESULT_SUCCESS or response_code != 200:
		error_received.emit()
		_is_requesting = false
		return
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	request_obj.queue_free()
	_is_requesting = false
	_players = response.players
	_update_players()
