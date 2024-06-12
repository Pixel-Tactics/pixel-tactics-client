extends Node

class_name InviteAPI

signal auth_received
signal session_started
signal invited

enum AuthStatus {
	NOT_SET,
	LOADING,
	SET,
}

@onready var auth_handler = $AuthHandler
@onready var start_session_handler = $StartSessionHandler
@onready var create_session_handler = $CreateSessionHandler
@onready var invite_session_handler = $InviteSessionHandler

var websocket_url = ""
var socket: WebSocketPeer = WebSocketPeer.new()
var auth_status = AuthStatus.NOT_SET

var _id_to_name = {}
var _name_to_handler = {}
var _request_queue = []

func _ready():
	_name_to_handler = {
		"AUTH": auth_handler,
		"CREATE_SESSION": create_session_handler,
		"START_SESSION": start_session_handler,
		"INVITE_SESSION": invite_session_handler,
	}
	auth_handler.success_received.connect(_on_auth_success)
	start_session_handler.success_received.connect(_on_session_start)
	invite_session_handler.success_received.connect(_on_invite)
	
	websocket_url = ProjectSettings.get_setting("application/config/match_service_url")

func _process(_delta):
	if Global.user == null:
		return
	
	socket.poll()
	var state = socket.get_ready_state()
	if state == WebSocketPeer.STATE_CLOSED:
		auth_status = AuthStatus.NOT_SET
		socket = WebSocketPeer.new()
		socket.connect_to_url(websocket_url)
	elif state == WebSocketPeer.STATE_OPEN:
		if auth_status == AuthStatus.NOT_SET:
			auth_status = AuthStatus.LOADING
			auth_handler.send({
				"player_token": Global.user.token
			}, _get_identifier(), socket)
		elif len(_request_queue) > 0:
			while len(_request_queue) > 0:
				var cur_request = _request_queue[0]
				_request_queue.pop_front()
				send_request(cur_request.handler_name, cur_request.message)
		else:
			while socket.get_available_packet_count():
				var cur_packet = socket.get_packet()
				var message = JSON.parse_string(cur_packet.get_string_from_utf8())
				if auth_status == AuthStatus.LOADING:
					auth_handler.handle_incoming(message)
				else:
					var cur_id = message.identifier
					if not _id_to_name.has(cur_id):
						if message.action.substr(0, 6) == "ERROR_":
							_name_to_handler[message.action.substr(6)].handle_error(message)
						else:
							_name_to_handler[message.action].handle_incoming(message)
					else:
						if message.action == "FEEDBACK":
							_name_to_handler[_id_to_name[cur_id]].handle_incoming(message)
						elif message.action == "ERROR_FEEDBACK":
							_name_to_handler[_id_to_name[cur_id]].handle_error(message)

var next_identifier = 1
func _get_identifier():
	var cur = next_identifier
	next_identifier = next_identifier + 1
	return str(cur)

func send_request(handler_name, message = {}):
	var state = socket.get_ready_state()
	if state != WebSocketPeer.STATE_OPEN:
		_request_queue.push_back({
			"handler_name": handler_name,
			"message": message,
		})
	else:
		var handler = _name_to_handler[handler_name]
		var cur_id = _get_identifier()
		_id_to_name[cur_id] = handler_name
		handler.send(message, cur_id, socket)

func _on_auth_success():
	auth_status = AuthStatus.SET
	emit_signal("auth_received")

func _on_auth_error():
	auth_status = AuthStatus.NOT_SET

func _on_session_start(session_id: String):
	emit_signal("session_started", session_id)

func _on_invite(player_id):
	emit_signal("invited", player_id)
