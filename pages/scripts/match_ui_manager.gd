extends CanvasLayer

signal credentials_submitted

@export var credentials_ui_path: String
@export var loading_ui_path: String
@export var prepare_ui_path: String

var credentials_ui_template = null
var loading_ui_template = null
var prepare_ui_template = null

var current_ui = null

func _ready():
	credentials_ui_template = load(credentials_ui_path)
	loading_ui_template = load(loading_ui_path)
	prepare_ui_template = load(prepare_ui_path)
	current_ui = loading_ui_template.instantiate()
	self.add_child(current_ui)

func _on_credentials_submit(player_id: String, opponent_id: String):
	emit_signal("credentials_submitted", player_id, opponent_id)

func ChangeUI(ui_type: String, init_dict: Dictionary = {}):
	self.remove_child(current_ui)
	match ui_type:
		"CREDENTIALS":
			current_ui = credentials_ui_template.instantiate()
			current_ui.submitted.connect(_on_credentials_submit.bind())
		"LOADING":
			current_ui = loading_ui_template.instantiate()
		"PREPARATION":
			current_ui = prepare_ui_template.instantiate()
			current_ui.init(init_dict.hero_list, init_dict.end_time)
	self.add_child(current_ui)
