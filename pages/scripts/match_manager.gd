extends Node

class_name MatchManager

@onready var match_api = $MatchAPI
@onready var map_manager = $Map
@onready var ui_manager = $UI

var current_state: SessionState = null
var match_data = Session.new()

func _ready():
	current_state = CredentialsState.new(self)

func _process(_delta):
	if current_state != null:
		current_state.update()

func change_match_state(new_state: SessionState):
	current_state.clear()
	current_state = new_state
