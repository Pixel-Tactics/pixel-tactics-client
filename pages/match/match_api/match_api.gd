extends Node

class_name MatchAPI

signal auth_received
signal session_started
signal time_synced
signal session_get
signal player_prepared
signal state_changed
signal move_accepted
signal attack_accepted

enum AuthStatus {
	NOT_SET,
	LOADING,
	SET,
}

@onready var auth_handler = $AuthHandler
@onready var start_session_handler = $StartSessionHandler
@onready var create_session_handler = $CreateSessionHandler
@onready var server_time_handler = $ServerTimeHandler
@onready var get_session_handler = $GetSessionHandler
@onready var prepare_player_handler = $PreparePlayerHandler
@onready var state_change_handler = $StateChangeHandler
@onready var execute_action_handler = $ExecuteActionHandler
@onready var apply_action_handler = $ApplyActionHandler
@onready var end_turn_handler = $EndTurnHandler

@export var websocket_url = "ws://127.0.0.1:8080/ws"
var socket: WebSocketPeer = WebSocketPeer.new()
var auth_status = AuthStatus.NOT_SET

var id_to_name = {}
var name_to_handler = {}

var player_id: String = ""
var opponent_id: String = ""

func init(new_player_id: String, new_opponent_id: String):
	if auth_status == AuthStatus.NOT_SET:
		player_id = new_player_id
		opponent_id = new_opponent_id
		socket.connect_to_url(websocket_url)

func _ready():
	name_to_handler = {
		"AUTH": auth_handler,
		"CREATE_SESSION": create_session_handler,
		"START_SESSION": start_session_handler,
		"SERVER_TIME": server_time_handler,
		"GET_SESSION": get_session_handler,
		"PREPARE_PLAYER": prepare_player_handler,
		"STATE_CHANGE": state_change_handler,
		"EXECUTE_ACTION": execute_action_handler,
		"APPLY_ACTION": apply_action_handler,
		"END_TURN": end_turn_handler,
	}
	auth_handler.connect("success_received", _on_auth_success.bind())
	start_session_handler.connect("success_received", _on_session_start.bind())
	server_time_handler.connect("success_received", _on_time_sync.bind())
	get_session_handler.connect("success_received", _on_get_session.bind())
	prepare_player_handler.connect("success_received", _on_player_prepared.bind())
	state_change_handler.connect("success_received", _on_state_change.bind())
	apply_action_handler.connect("move_accepted", _on_move_accept.bind())
	#apply_action_handler.connect("attack_accepted", _on_attack_accept.bind())
	apply_action_handler.connect("attack_accepted", _on_attack_accept.bind())
	apply_action_handler.attack_accepted.connect(_on_attack_accept.bind())

func _process(_delta):
	if player_id == "" or opponent_id == "":
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
				"player_token": player_id
			}, _get_identifier(), socket)
		else:
			while socket.get_available_packet_count():
				var cur_packet = socket.get_packet()
				var message = JSON.parse_string(cur_packet.get_string_from_utf8())
				print(message)
				if auth_status == AuthStatus.LOADING:
					auth_handler.handle_incoming(message)
				else:
					var cur_id = message.identifier
					if not id_to_name.has(cur_id):
						if message.action.substr(0, 6) == "ERROR_":
							name_to_handler[message.action.substr(6)].handle_error(message)
						else:
							name_to_handler[message.action].handle_incoming(message)
					else:
						if message.action == "FEEDBACK":
							name_to_handler[id_to_name[cur_id]].handle_incoming(message)
						elif message.action == "ERROR_FEEDBACK":
							name_to_handler[id_to_name[cur_id]].handle_error(message)

var next_identifier = 1
func _get_identifier():
	var cur = next_identifier
	next_identifier = next_identifier + 1
	return str(cur)

func send_request(handler_name, message = {}):
	var handler = name_to_handler[handler_name]
	var cur_id = _get_identifier()
	id_to_name[cur_id] = handler_name
	handler.send(message, cur_id, socket)

func _on_auth_success():
	auth_status = AuthStatus.SET
	emit_signal("auth_received", player_id, opponent_id)

func _on_auth_error():
	auth_status = AuthStatus.NOT_SET
	player_id = ""
	opponent_id = ""

func _on_session_start(session_id: String):
	emit_signal("session_started", session_id)

func _on_get_session(session_data: Dictionary):
	emit_signal("session_get", session_data)

func _on_time_sync():
	emit_signal("time_synced")

func _on_player_prepared():
	emit_signal("player_prepared")
	
func _on_state_change(session_data: Dictionary):
	emit_signal("state_changed", session_data)

func _on_move_accept(action_data: Dictionary):
	emit_signal("move_accepted", action_data)

func _on_attack_accept(action_data: Dictionary):
	print("HEMMMMM")
	emit_signal("attack_accepted", action_data)
