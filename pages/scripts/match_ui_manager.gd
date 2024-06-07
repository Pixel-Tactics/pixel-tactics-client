extends CanvasLayer

class_name MatchUIManager

signal credentials_submitted
signal hero_submitted
signal hero_start_request
signal end_turn
signal forfeit

@export var credentials_ui_path: String
@export var loading_ui_path: String
@export var prepare_ui_path: String
@export var battle_ui_path: String

var credentials_ui_template = null
var loading_ui_template = null
var prepare_ui_template = null
var battle_ui_template = null

var current_ui = null

func _ready():
	credentials_ui_template = load(credentials_ui_path)
	loading_ui_template = load(loading_ui_path)
	prepare_ui_template = load(prepare_ui_path)
	battle_ui_template = load(battle_ui_path)
	current_ui = loading_ui_template.instantiate()
	self.add_child(current_ui)

func _on_credentials_submit(player_id: String, opponent_id: String):
	emit_signal("credentials_submitted", player_id, opponent_id)

func _on_hero_submit(hero_list: Array):
	emit_signal("hero_submitted", hero_list)
	
func _on_hero_start_request(hero: BaseHero):
	emit_signal("hero_start_request", hero)

func _on_end_turn():
	emit_signal("end_turn")

func _on_forfeit():
	emit_signal("forfeit")

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
			current_ui.submitted.connect(_on_hero_submit.bind())
		"BATTLE":
			current_ui = battle_ui_template.instantiate()
			current_ui.init(init_dict.player, init_dict.opponent, init_dict.init_is_player, init_dict.init_deadline)
			current_ui.hero_action_start_request.connect(_on_hero_start_request.bind())
			current_ui.end_turn.connect(_on_end_turn.bind())
			current_ui.forfeit.connect(_on_forfeit.bind())
	self.add_child(current_ui)
