extends CanvasLayer

class_name MatchUIManager

signal credentials_submitted
signal hero_submitted
signal hero_start_request
signal end_turn
signal forfeit
signal main_menu

var loading_ui_template = preload("res://ui/match/match_ui/loading/match_loading_ui.tscn")
var prepare_ui_template = preload("res://ui/match/match_ui/prepare/match_prepare_ui.tscn")
var battle_ui_template = preload("res://ui/match/match_ui/battle/match_battle_ui.tscn")
var results_ui_template = preload("res://ui/match/match_ui/results/results_ui.tscn")

var current_ui = null

func _ready():
	current_ui = loading_ui_template.instantiate()
	self.add_child(current_ui)

func _on_hero_submit(hero_list: Array):
	emit_signal("hero_submitted", hero_list)
	
func _on_hero_start_request(hero: BaseHero):
	emit_signal("hero_start_request", hero)

func _on_end_turn():
	emit_signal("end_turn")

func _on_forfeit():
	emit_signal("forfeit")
	
func _on_main_menu():
	emit_signal("main_menu")

func ChangeUI(ui_type: String, init_dict: Dictionary = {}):
	self.remove_child(current_ui)
	match ui_type:
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
		"RESULTS":
			current_ui = results_ui_template.instantiate()
			current_ui.back_to_menu.connect(_on_main_menu)
	self.add_child(current_ui)
